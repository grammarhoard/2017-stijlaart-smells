module smells::ImproperResponsibility

import grammarlab::language::Grammar;
import GrammarUtils;
import Set;
import IO;
import Map;
import Map::Extra;
import List;
import Violations;

set[Violation] violations(grammarInfo(g, grammarData(_, nprods, expressionIndex,_,_), _)) =	
	{ <violatingExpression(c), improperResponsibility()>
	| k <- expressionIndex
	, fullExpr(c) := k, choice(xs) := c
	, size(toSet(allHeads(nprods, xs, g))) == 1
	};


list[GExpr] allHeads(map[str, set[GProd]] nprods, list[GExpr] xs, GGrammar theGrammar) =
	[ headOfExpression(nprods, x, theGrammar, {}) | x <- xs ];


GExpr headOfExpression(map[str, set[GProd]] nprods, GExpr x, GGrammar theGrammar, set[str] viewed) =
	resolveNonterminal(nprods, firstExpr(x), theGrammar, viewed);
	
GExpr resolveNonterminal(map[str, set[GProd]] nprods, GExpr x, GGrammar theGrammar, set[str] viewed) {
	if (nonterminal(s) := x) {
		set[GProd] prods = nprods[s]? ? nprods[s] : {};
		if (size(prods) == 1) {
			production(lhs, rhs) = getOneFrom(prods);
			if (lhs in viewed) {
				return x;
			} else {
				return headOfExpression(nprods, rhs, theGrammar, viewed + {lhs});
			}
		} else {
			return choice([ rhs | prod <- prods, production(lhs,rhs) := prod ]);
		}
	} else {
		return x;
	}
}

GExpr firstExpr(GExpr x) {
	if (sequence(ys) := x) {
		return firstExpr(head(ys));
	} else {
	 	return x;
	}
}