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

import Violations;
import GrammarInformation;
import Map::Extra;

alias GrammarAnalysis = tuple[loc l, GrammarInfo gInfo, set[Violation] violations];

void run() {
	list[loc] inputFiles = Input::extractedGrammarLocationsInDir(|project://grammarsmells/input/zoo|);
	//inputFiles = take(12, drop(0, inputFiles));
	
	println("Loading grammar info for locations");
	pairs = [ <l,GrammarInformation::build(l)> | l <- inputFiles];
	
	exportReferencingInfo(pairs);
	writeGrammarStats(pairs);
	writeMixedDefinitionStats(pairs);
	list[GrammarAnalysis] result = [];
	
	//TODO Remove take/drop
	result = for (<y, gInfo> <- take(10,drop(0, pairs))) {
		println("Analysing <y>...");
		set[Violation] vs = smellsInGrammar(gInfo);
		append <y, gInfo, vs>;
		//println("<size(vs)>\t<y>");
	}
	for (<l,g,vs> <- result) {
		list[str] proxies = [ n | v <- vs , <violatingNonterminal(n),redirectingNonterminal()> := v];
		grammarInfo(grammar(ns, _, _), _, _) = g;
		//println("<size(proxies)> / <size(toSet(ns))>\t(<size(proxies) / 1.0 / size(toSet(ns))>)\t | <l>"); 
	}
	//iprintln(size({ l | <l, g, v> <- result, /proxyNonterminal() := v }));
}


void exportReferencingInfo(list[tuple[loc, GrammarInfo]] inputFiles) {
	list[value] x = [referenceInfoJson(l, i) | <l,gInfo> <- inputFiles, i := getReferenceInfo(gInfo)];
	IO::writeFile(|project://grammarsmells/output/reference-info.json|, toJSON(x, true));
}

value referenceInfoJson(loc l, ReferenceInfo i:referenceInfo(up,down,dir,ratio)) =
	( "location" : "<l>"
	, "up" : up
	, "down" : down
	, "dir" : dir == downReferencing() ? "DOWN" : dir == upReferencing() ? "UP" : "EVEN"
	, "ratio" : ratio
	);


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

void writeMixedDefinitionStats(list[tuple[loc, GrammarInfo]] input) {
	lrel[loc,set[DefinitionDirection]] definitionStyleList = [ <l,definitionStyles(gInfo)> | <l,gInfo> <- input];
	list[value] x = [ mixedDefinitonJson(l, defs) | <l, defs> <- definitionStyleList];
	lrel[bool,bool,bool] triples = [ <(/horizontal(_) := ds), (/vertical(_) := ds), (/zigZag(_) := ds)> | <_,ds> <- definitionStyleList ];
	
	map[tuple[bool,bool,bool],int] m = ( <a,b,c> : 0 | a <- {true,false}, b <- {true,false}, c <- {true,false} );
	m = ( m | incK(it,k, 1) | k <- triples);
	map[str,int] totals = ( directionTotals({}) | merge(it, directionTotals(v), (int)(int a, int b){return a + b;} ) | <_,v> <- definitionStyleList);
	
	overall = ( "file_types" : ("<a>_<b>_<c>" : m[<a,b,c>] | <a,b,c> <- m)
			  , "totals" : totals 
			  );
			  
	IO::writeFile(
		|project://grammarsmells/output/mixed-definitions.json|,
		toJSON( ( "files" : x, "overall" : overall), true)
	);	
}

map[str, int] directionTotals(set[DefinitionDirection] x) =
	( "horizontals" : size({ v | v:horizontal(_) <- x})
	, "verticals" : size({ v | v:vertical(_) <- x})
	, "zigzags" : size({ v | v:zigZag(_) <- x})
	, "undecided" : size({ v | v:undecided(_) <- x})
	);

value mixedDefinitonJson(loc l, set[DefinitionDirection] x) {
	map[str, value] r = directionTotals(x);
	r["location"] = "<l>";
	return r;
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
	+ smells::SmallAbstractions::violations(gInfo)
	+ smells::UpDownReferences::violations(gInfo)
	;

