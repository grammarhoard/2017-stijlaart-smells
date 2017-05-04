module Main

import IO;
import grammarlab::io::read::BGF;
import List;
import Input;
import grammarlab::language::Grammar;
import GrammarUtils;
import Map;
import Set;
import Relation;
import util::Math;
import lang::json::IO;

import smells::DisconnectedNonterminalGraph;
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
import smells::SmallAbstractions;
import smells::UpDownReferences;

import output::MixedDefinitions;
import output::UpDownReferences;

import Violations;
import GrammarInformation;
import Map::Extra;
import smells::Size;

alias GrammarAnalysis = tuple[loc l, GrammarInfo gInfo, set[Violation] violations];

lrel[loc, GrammarInfo] getInputFiles() {
	list[loc] inputFiles = Input::extractedGrammarLocationsInDir(|project://grammarsmells/input/zoo|);
	//inputFiles = take(1, drop(0, inputFiles));
	println("Loading grammar info for locations");
	pairs = for (l <- inputFiles) {
		println("Loading <l>... ");
		append <l,GrammarInformation::build(l)>;
	}
	return
		[ <l, i>
		| <l,i> <- pairs
		, grammarInfo(grammar(ns,_,_),_,_) := i
		, size(ns) > 0
		];
}

void export() {
	lrel[loc, GrammarInfo] pairs = getInputFiles();
	println("<size(pairs)> input files.");
	
	println("Write grammar stats");
	writeGrammarStats(pairs);
	
	println("Write mixed definition stats ...");
	output::MixedDefinitions::writeMixedDefinitionStats(pairs);
	
	println("Write mixed up and down referencing stats ...");
	output::UpDownReferences::export(pairs);
}

void runSize() {
	for (<l,i> <- getInputFiles()) {
		iprintln(l);
		iprintln(
		smells::Size::stuff(i)
		)
		;
	}
}
void run() {
	lrel[loc, GrammarInfo] pairs = getInputFiles();
	println("<size(pairs)> input files.");
	list[GrammarAnalysis] result = [];
	
	result = for (<y, gInfo> <- pairs) {
		println("Analysing <y>...");
		set[Violation] vs = smellsInGrammar(gInfo);
		//iprintln(vs);
		append <y, gInfo, vs>;
	}
	
	exportReferenceDistanceSmellData(result);
	exportRedirectingNonterminalSmellData(result);
}

void exportRedirectingNonterminalSmellData (list[GrammarAnalysis] result) {
	map[loc, int] byFile = ( l : size([ lhs | v <- vs , <lhs,redirectingNonterminal()> := v] ) | <l,g,vs> <- result );
	map[str,int] d = ( "<k>" : byFile[k] | k  <- byFile);
	iprintln(byFile);
	IO::writeFile(|project://grammarsmells/output/redirecting-nonterminals-by-file.json|, toJSON(d, true));
}
void exportReferenceDistanceSmellData(list[GrammarAnalysis] result) {
	map[loc, int] byFile = ( l : size([ n.lhs | v <- vs , <violatingProduction(n),referenceDistanceJumpOver(_, _,_)> := v] ) | <l,g,vs> <- result );
	map[str,int] d = ( "<k>" : byFile[k] | k  <- byFile);
	IO::writeFile(|project://grammarsmells/output/reference-distance-smell-by-file.json|, toJSON(d, true));
}
 
void writeGrammarStats(list[tuple[loc, GrammarInfo]] inputFiles) {
	list[value] x = [ grammarStatsJson(l, gInfo) | <l,gInfo> <- inputFiles];
	IO::writeFile(|project://grammarsmells/output/grammar-stats.json|, toJSON(x, true));
}

value grammarStatsJson(loc l, grammarInfo(g:grammar(ns,ps,ss), grammarData(_,_,_,tops,bottoms), _)) =
		( "location": "<l>"
		, "nonterminals" : size(ns)
		, "productions" : size(ps)
		, "tops" : size(tops)
		, "bottoms" :size(bottoms)
		, "terminals" : "TODO"
		, "structures" : "TODO"
		);




set[Violation] smellsInGrammar(gInfo) =
	//   smells::DisconnectedNonterminalGraph::violations(gInfo)
	//+ smells::Duplication::violations(gInfo)
	//+ smells::EntryPoint::violations(gInfo)
	//+ smells::FakeZeroOrMore::violations(gInfo)
	//+ smells::FakeOneOrMore::violations(gInfo)
	//+ smells::ImproperResponsibility::violations(gInfo)
	//+ smells::LegacyStructures::violations(gInfo)
	//+ smells::MixedDefinitions::violations(gInfo)
	//+ smells::MixedTop::violations(gInfo)
	//+ 
	smells::ProxyNonterminals::violations(gInfo)
	//+ smells::ReferenceDistance::violations(gInfo)
	//+ smells::ScatteredNonterminalProductionRules::violations(gInfo)
	//+ smells::SingleListThingy::violations(gInfo)
	//+ smells::SmallAbstractions::violations(gInfo)
	//+ smells::UpDownReferences::violations(gInfo)
	;

