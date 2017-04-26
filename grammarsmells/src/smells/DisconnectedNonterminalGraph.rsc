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

set[str] violations(grammarInfo( g:grammar(ns,_,_), grammarData(r, _, expressionIndex, t,_), facts)) {
	rel[str,str] reflSymTranClos = (r + invert(r))+;
	indexed = index(reflSymTranClos);
	return { n | n <- toSet(ns), n notin t, ms := indexed[n], (ms & t) == {} };
}