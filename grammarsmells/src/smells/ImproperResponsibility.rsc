module smells::ImproperResponsibility

import grammarlab::language::Grammar;
import GrammarUtils;
import Set;
import IO;
import Map;
import Map::Extra;
import List;

set[GExpr] violations(GGrammar theGrammar) {
	map[ExpressionOccurence, set[ExpressionOccurenceLocation]] index = buildExpressionIndex(theGrammar);
	list[GExpr] result = [];
	result = for (k <- index, fullExpr(c) := k, choice(xs) := c) {
		list[GExpr] firstsForK = allHeads(xs, theGrammar);
		set[GExpr] firstForKSet = toSet(firstsForK);
		if (size(firstForKSet) == 1) {
			append c;
		}
	}
	return toSet(result);
}

list[GExpr] allHeads(list[GExpr] xs, GGrammar theGrammar) {
	return [ headOfExpression(x, theGrammar, {}) | x <- xs ];
}

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