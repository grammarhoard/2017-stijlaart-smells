module smells::DisconnectedNonterminalGraph


import grammarlab::language::Grammar;
import GrammarUtils;
import Set;
import IO;
import Map;
import Relation;
import Map::Extra;
import List;
import GrammarInformation;
import Violations;

set[Violation] violations(grammarInfo( g:grammar(ns,_,_), grammarData(r, _, expressionIndex, t,_), facts)) {
	rel[str,str] reflSymTranClos = (r + invert(r))+;
	indexed = index(reflSymTranClos);
	return  { <violatingNonterminal(n), disconnectedFromTop()> | n <- toSet(ns), n notin t, ms := indexed[n], (ms & t) == {} };
}