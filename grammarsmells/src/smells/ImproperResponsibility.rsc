module smells::ImproperResponsibility

import grammarlab::language::Grammar;
import GrammarUtils;
import Set;
import IO;
import Map;
import Map::Extra;
import List;

set[GExpr] violations(grammarInfo(g, grammarData(_, _, expressionIndex,_,_), _)) =	
	{ c
	| k <- expressionIndex
	, fullExpr(c) := k, choice(xs) := c
	, size(toSet(allHeads(xs, g))) == 1
	};


list[GExpr] allHeads(list[GExpr] xs, GGrammar theGrammar) =
	[ headOfExpression(x, theGrammar, {}) | x <- xs ];


GExpr headOfExpression(GExpr x, GGrammar theGrammar, set[str] viewed) =
	resolveNonterminal(firstExpr(x), theGrammar, viewed);
	
GExpr resolveNonterminal(GExpr x, GGrammar theGrammar, set[str] viewed) {
	if (nonterminal(s) := x) {
		set[GProd] prods = prodsForNonterminal(theGrammar, s);
		if (size(prods) == 1) {
			production(lhs, rhs) = getOneFrom(prods);
			if (lhs in viewed) {
				return x;
			} else {
				return headOfExpression(rhs, theGrammar, viewed + {lhs});
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