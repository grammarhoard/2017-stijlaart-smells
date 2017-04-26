module smells::Duplication

import grammarlab::language::Grammar;
import GrammarUtils;
import Set;
import IO;
import Map;
import Map::Extra;
import Violations;

bool isNonterminal(ExpressionOccurence x) {
	if (fullExpr(nonterminal(_)) := x) {
		return true;
	} else if (partialExpr([nonterminal(_)]) := x) {
		return true;
	} else {
		return false;
	}
}

bool isTerminal(ExpressionOccurence x) {
	if (fullExpr(terminal(_)) := x) {
		return true;
	} else if (partialExpr([terminal(_)]) := x) {
		return true;
	} else {
		return false;
	}
}

set[set[GProd]] duplicateProductionRules(map[ExpressionOccurence, set[ExpressionOccurenceLocation]] index) {
	return { l | k <- index, fullExpr(_) := k, l := { v | occurenceRule(v) <- index[k]}, size(l) > 1 };
}


rel[GExpr, GProd, GProd] knownSubexpression(map[ExpressionOccurence, set[ExpressionOccurenceLocation]] index) = 
	( {}
	| it + 
		{ <l, s, r> 
		| n <- index[k]
		, occurenceRule(r) := n
		, m <- index[k]
		, occurenceSubExpr(s) := m
		}
	| k <- index
	, size(index[k]) > 1
	, fullExpr(l) := k
	, nonterminal(_) !:= l);

rel[GExpr, set[GProd]] commonSubexpressions(map[ExpressionOccurence, set[ExpressionOccurenceLocation]] index) {
	set[tuple[GExpr, GProd, GProd]] triples =
		( {}
		| it + 
			{ <full,s,r> 
			| n <- index[k]
			, occurenceSubExpr(r) := n
			, m <- index[k]
			, occurenceSubExpr(s) := m
			}
		| k <- index
		, size(index[k]) > 1
		, fullExpr(full) := k
		, nonterminal(_) !:= full
		, terminal(_) !:= full
		);
	map[GExpr, set[GProd]] indexedExpressions = ( () | addItemToValueSet(addItemToValueSet(it, a, b), a, c) | <a,b,c> <- triples );
	return { <k, indexedExpressions[k]> | k <- indexedExpressions};
}

set[Violation] violations(grammarInfo(g, grammarData(_, _, expressionIndex,_,_), facts))	
	= { <violatingProductions(rules), duplicateRules()> | rules <- duplicateProductionRules(expressionIndex) }
	+ { <violatingProductions({b,c}), definedSubExpression(a,b,c)> | <a,b,c> <- knownSubexpression(expressionIndex)}
	+ { <violatingProductions(xs), commonSubExpression(a)> | <a,xs> <- commonSubexpressions(expressionIndex)}
	;
	