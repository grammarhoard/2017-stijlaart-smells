module smells::ProxyNonterminals

import grammarlab::language::Grammar;
import GrammarUtils;
import List;
import Set;
import IO;
import ListRelation;
import Violations;

set[Violation] violations(grammarInfo(g:grammar(ns,_,_), grammarData(_, nprods, expressionIndex, tops, _), _)) {
	lrel[GProd, str] refers = prodReferences(g);
	set[str] redirects = singleNonterminalProductionRules(nprods, g);
	set[str] singleUsages = { n | n <- range(refers), n in ns, size(rangeR(refers, {n})) == 1};
	return 
		{ <violatingNonterminal(n), redirectingNonterminal()> | n <- redirects}
		++ { <violatingNonterminal(n), singleUsageNonterminal(nprods[n])> | n <- singleUsages };
}

set[str] singleNonterminalProductionRules(map[str, set[GProd]] nprods, GGrammar g:grammar(_,ps,_)) =
	{ lhs 
	| production(lhs, rhs) <- ps
	, size(nprods[lhs]) == 1
	, nonterminal(x) := rhs
	};
