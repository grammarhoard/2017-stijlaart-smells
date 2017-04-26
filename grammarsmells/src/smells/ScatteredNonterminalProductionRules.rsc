module smells::ScatteredNonterminalProductionRules

import grammarlab::language::Grammar;
import GrammarUtils;
import Set;
import IO;
import Map;
import Relation;
import Map::Extra;
import List;


set[str] violations(grammarInfo(grammar(ns,ps,_), grammarData(r, nprods, _, _, _), _)) =
	{ n
	| n <- ns
	, isScattered(ps, nprods[n])
	};
	

bool isScattered(list[GProd] haystack, set[GProd] needles) {
	set[int] indexes =  {indexOf(haystack, needle) | needle <- needles };
	return (max(indexes) - min(indexes)) >= size(needles); 
}