module Main

import IO;
import grammarlab::io::read::BGF;
import List;
import Input;
import grammarlab::language::Grammar;
import GrammarUtils;
import Map;
import Set;
import util::Math;

import smells::DisconnectedNonterminalGraph;
import smells::UpDownReferences;
import smells::ProxyNonterminals;
import smells::NamingConvention;
import smells::FakeOneOrMore;
import smells::FakeZeroOrMore;
import smells::Duplication;
import smells::ImproperResponsibility;
import smells::MixedDefinitions;
import smells::LegacyStructures;
import smells::EntryPoint;
import smells::MixedTop;
import smells::ProxyNonterminals;
import smells::ReferenceDistance;
import smells::ScatteredNonterminalProductionRules;
import smells::SingleListThingy;

import GrammarInformation;

void run() {
	x = Input::extractedGrammarLocationsInDir(|project://grammarsmells/input/zoo|);
		
	for (loc y <- drop(0, x)) {
		GGrammar theGrammar = readBGF(y);
		iprintln(y);
		grammar(n,p,s) = theGrammar;
		
		GrammarInfo gInfo = GrammarInformation::build(theGrammar);
		
		smells::DisconnectedNonterminalGraph::violations(gInfo);
		smells::Duplication::violations(gInfo);
		smells::EntryPoint::violations(gInfo);
		smells::FakeZeroOrMore::violations(gInfo);
		smells::FakeOneOrMore::violations(gInfo);
		smells::ImproperResponsibility::violations(gInfo);
		smells::LegacyStructures::violations(gInfo);
		smells::MixedDefinitions::violations(gInfo);
		smells::MixedTop::violations(gInfo);
		smells::ProxyNonterminals::violations(gInfo);
		smells::ReferenceDistance::violations(gInfo);
		smells::ReferenceDistance::referenceDistances(gInfo);
		smells::ScatteredNonterminalProductionRules::violations(gInfo);
		smells::SingleListThingy::violations(gInfo);
		smells::UpDownReferences::violations(gInfo);
	}
}
