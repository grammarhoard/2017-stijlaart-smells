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

import smells::FakeZeroOrMore;
import GrammarInformation;

void run() {
	x = Input::extractedGrammarLocationsInDir(|project://grammarsmells/input/zoo|);
		
	for (loc y <- drop(0, x)) {
		GGrammar theGrammar = readBGF(y);
		iprintln(y);
		grammar(n,p,s) = theGrammar;
		
		GrammarInfo gInfo = GrammarInformation::build(theGrammar);
		//set[str] a = smells::MixedTop::violations(theGrammar);
		//set[str] b = smells::EntryPoint::violations(theGrammar);
		//set[str] result = smells::DisconnectedNonterminalGraph::violations(theGrammar);
		//iprintln(c);
		//iprintln(b);
		//iprintln(result);
		
		//smells::DisconnectedNonterminalGraph::violations(gInfo);
		//smells::Duplication::violations(gInfo);
		//smells::EntryPoint::violations(gInfo);
		//smells::FakeZeroOrMore::violations(gInfo);
		//smells::FakeOneOrMore::violations(gInfo);
		//smells::ImproperResponsibility::violations(gInfo);
		//smells::LegacyStructures::violations(gInfo);
		//smells::MixedDefinitions::violations(gInfo);
		//smells::MixedTop::violations(gInfo);
		//smells::ProxyNonterminals::violations(gInfo);
		//smells::ReferenceDistance::violations(gInfo);
		//smells::ReferenceDistance::referenceDistances(gInfo);
		//smells::ScatteredNonterminalProductionRules::violations(gInfo);
		//smells::SingleListThingy::violations(gInfo);
		smells::UpDownReferences::violations(gInfo);
		
		//if (size(result) > 0) {
			//iprintln(result);
			//return;
		//}
		//return;
	}
}
