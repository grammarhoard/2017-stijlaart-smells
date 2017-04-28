module smells::ProxyNonterminals

import grammarlab::language::Grammar;
import GrammarUtils;
import List;
import Set;
import IO;
import ListRelation;
import Violations;

set[Violation] violations(grammarInfo(g:grammar(ns,ps,_), grammarData(_, nprods, expressionIndex, tops, _), _)) =
	{ <violatingNonterminal(lhs), redirectingNonterminal()>
	| production(lhs, rhs) <- ps
	, size(nprods[lhs]) == 1
	, nonterminal(x) := rhs
	};
