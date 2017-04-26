module smells::EntryPoint



import grammarlab::language::Grammar;
import GrammarUtils;
import Set;
import IO;
import Map;
import Relation;
import Map::Extra;
import List;


set[str] violations(grammarInfo(grammar(ns,_,_), grammarData(_, _, expressionIndex, tops, _), facts)) =
	size(tops) == 1 ? {} : (isEmpty(tops) ? toSet(ns) : tops);