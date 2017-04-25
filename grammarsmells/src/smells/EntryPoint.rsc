module smells::EntryPoint



import grammarlab::language::Grammar;
import GrammarUtils;
import Set;
import IO;
import Map;
import Relation;
import Map::Extra;
import List;


set[str] violations(GGrammar theGrammar:grammar(ns,ps,ss)) {
	rel[str,str] r = nonterminalReferences(theGrammar);
	set[str] setNs = toSet(ns);
	set[str] referred = range(r);
	set[str] tops = setNs - referred;
	set[str] emptySet = {};
	return size(tops) == 1 ? emptySet : (isEmpty(tops) ? setNs : tops);
}