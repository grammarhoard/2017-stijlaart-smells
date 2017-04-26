module smells::EntryPoint



import grammarlab::language::Grammar;
import GrammarUtils;
import Set;
import IO;
import Map;
import Relation;
import Map::Extra;
import List;
import Violations;

set[Violation] violations(grammarInfo(grammar(ns,_,_), grammarData(_, _, expressionIndex, tops, _), facts)) =
	size(tops) == 1 ? {} : 
		{ <violatingNonterminals(tops), unclearEntryPoint()> };