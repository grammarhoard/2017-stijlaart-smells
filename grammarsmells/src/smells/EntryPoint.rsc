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
	set[str] tops = grammarTops(theGrammar);
	return size(tops) == 1 ? {} : (isEmpty(tops) ? toSet(ns) : tops);
}