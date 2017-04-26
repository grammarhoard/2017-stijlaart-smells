module smells::ProxyNonterminals

import grammarlab::language::Grammar;
import GrammarUtils;
import List;
import Set;
import IO;
import ListRelation;

set[str] singleNonterminalProductionRules(GGrammar g:grammar(_,ps,_)) =
	{ lhs 
	| production(lhs, rhs) <- ps
	, size(prodsForNonterminal(g, lhs)) == 1
	, nonterminal(x) := rhs
	};


set[str] violations(grammarInfo(g, grammarData(_, _, expressionIndex, tops, _), _)) {
	lrel[GProd, str] refers = prodReferences(g);
	set[str] redirects = singleNonterminalProductionRules(g);
	set[str] singleUsages = { n | n <- range(refers), size(rangeR(refers, {n})) == 1};
	return redirects + singleUsages;
}

