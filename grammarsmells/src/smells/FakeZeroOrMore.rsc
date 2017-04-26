module smells::FakeZeroOrMore


import IO;
import grammarlab::language::Grammar;
import GrammarInformation;
import GrammarUtils;
import List;
import Set;
import Relation;
import Facts;

set[GExpr] violations(grammarInfo(g, grammarData(_, _, expressionIndex,_,_), facts)) =
	facts[containsStar()]
	? { l 
	  | k <- expressionIndex
	  , fullExpr(l) := k
	  , optional(plus(_)) := l
	  }
    : {};