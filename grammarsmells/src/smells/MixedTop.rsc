module smells::MixedTop


import grammarlab::language::Grammar;
import GrammarUtils;
import Set;
import IO;
import Map;
import Relation;
import Map::Extra;
import List;
import Violations;

set[Violation] violations(grammarInfo(grammar(_, ps, _), grammarData(_, _, expressionIndex, tops, _), _)) {
	list[str] prodNs = [ lhs | production(lhs,_) <- ps];
	if(prodNs == []) {
		return {};
	}
	set[str] firstAndLast = {head(prodNs), last(prodNs)};
	
	if (tops != {} && (firstAndLast & tops) == {}) {
		return 
			{ < violatingNonterminals({ head(prodNs), last(prodNs)} + tops)
			  , mixedTops()
			  >
			};
	}  else {
		return {};
	}
}