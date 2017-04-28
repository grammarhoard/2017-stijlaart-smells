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

import Violations;
import GrammarInformation;

alias GrammarAnalysis = tuple[loc l, GrammarInfo gInfo, set[Violation] violations];

void run() {
	inputFiles = Input::extractedGrammarLocationsInDir(|project://grammarsmells/input/zoo|);
		
	list[GrammarAnalysis] result = [];
	result = for (loc y <- take(10,drop(0, inputFiles))) {
		iprintln("Analysing <y>...");
		GrammarInfo gInfo = GrammarInformation::build(y);
		set[Violation] vs = smellsInGrammar(gInfo);
		append <y, gInfo, vs>;
		//println("<size(vs)>\t<y>");
	}
	for (<l,g,vs> <- result) {
		list[str] proxies = [ n | v <- vs , <violatingNonterminal(n),redirectingNonterminal()> := v];
		//iprintln(proxies);
		grammarInfo(grammar(ns, _, _), _, _) = g;
		println("<size(proxies)> / <size(toSet(ns))>\t(<size(proxies) / 1.0 / size(toSet(ns))>)\t | <l>"); 
	}
	//iprintln(size({ l | <l, g, v> <- result, /proxyNonterminal() := v }));
}

set[Violation] smellsInGrammar(gInfo) =
	   smells::DisconnectedNonterminalGraph::violations(gInfo)
	+ smells::Duplication::violations(gInfo)
	+ smells::EntryPoint::violations(gInfo)
	+ smells::FakeZeroOrMore::violations(gInfo)
	+ smells::FakeOneOrMore::violations(gInfo)
	+ smells::ImproperResponsibility::violations(gInfo)
	+ smells::LegacyStructures::violations(gInfo)
	+ smells::MixedDefinitions::violations(gInfo)
	+ smells::MixedTop::violations(gInfo)
	+ smells::ProxyNonterminals::violations(gInfo)
	+ smells::ReferenceDistance::violations(gInfo)
	+ smells::ScatteredNonterminalProductionRules::violations(gInfo)
	+ smells::SingleListThingy::violations(gInfo)
	+ smells::UpDownReferences::violations(gInfo)
	;

