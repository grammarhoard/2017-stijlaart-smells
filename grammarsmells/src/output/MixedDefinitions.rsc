module output::MixedDefinitions

import Violations;
import GrammarInformation;
import smells::MixedDefinitions;
import Set;
import IO;
import Map::Extra;
import lang::json::IO;

void writeMixedDefinitionStats(list[tuple[loc, GrammarInfo]] input) {
	lrel[loc,set[DefinitionDirection]] definitionStyleList = 
		[ <l, smells::MixedDefinitions::definitionStyles(gInfo)>
		| <l, gInfo> <- input
		];
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

value mixedDefinitonJson(loc l, set[DefinitionDirection] x) {
	map[str, value] r = directionTotals(x);
	r["location"] = "<l>";
	return r;
}


map[str, int] directionTotals(set[DefinitionDirection] x) =
	( "horizontals" : size({ v | v:horizontal(_) <- x})
	, "verticals" : size({ v | v:vertical(_) <- x})
	, "zigzags" : size({ v | v:zigZag(_) <- x})
	, "undecided" : size({ v | v:undecided(_) <- x})
	);