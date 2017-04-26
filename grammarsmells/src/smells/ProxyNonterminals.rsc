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


set[str] violations(GGrammar theGrammar) {
	lrel[GProd, str] some = prodReferences(theGrammar);
	set[str] redirects = singleNonterminalProductionRules(theGrammar);
	set[str] singleUsages = { n | n <- range(some), size(rangeR(some, {n})) == 1};
	return redirects + singleUsages;
}

