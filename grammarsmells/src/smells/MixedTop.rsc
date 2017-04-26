module smells::MixedTop


import grammarlab::language::Grammar;
import GrammarUtils;
import Set;
import IO;
import Map;
import Relation;
import Map::Extra;
import List;


set[str] violations(GGrammar theGrammar:grammar(ns,ps,_)) {
	set[str] tops = grammarTops(theGrammar);
	list[str] prodNs = [ lhs | production(lhs,_) <- ps];
	
	set[str] firstAndLast = {head(prodNs), last(prodNs)};
	if (tops != {} && (firstAndLast & tops) == {}) {
		return {head(prodNs), last(prodNs)} + tops;
	}  else {
		return {};
	}
}