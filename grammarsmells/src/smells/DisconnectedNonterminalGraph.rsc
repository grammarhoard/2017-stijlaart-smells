module smells::DisconnectedNonterminalGraph


import grammarlab::language::Grammar;
import GrammarUtils;
import Set;
import IO;
import Map;
import Relation;
import Map::Extra;
import List;


set[str] violations(GGrammar g:grammar(ns,ps,ss)){
	set[str] t = grammarTops(g);
	//iprintln(t);
	rel[str,str] r = nonterminalReferences(g);
	rel[str,str] reflSymTranClos = (r + invert(r))+;
	return { n | n <- toSet(ns), n notin t, ms := domain(rangeR(reflSymTranClos, {n})), (ms & t) == {} };
}