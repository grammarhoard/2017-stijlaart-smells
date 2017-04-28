module smells::SmallAbstractions

import grammarlab::language::Grammar;
import GrammarUtils;
import List;
import Set;
import IO;
import ListRelation;
import Violations;

set[Violation] violations(grammarInfo(g:grammar(ns,_,_), grammarData(_, nprods, expressionIndex, tops, _), _)) =
	{ <violatingNonterminal(n), singleUsageNonterminal(nprods[n])>
	| n <- range(prodReferences(g))
	, n in ns
	, size(rangeR(refers, {n})) == 1
	};