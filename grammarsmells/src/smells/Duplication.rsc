module smells::Duplication

import grammarlab::language::Grammar;
import GrammarUtils;
import Set;
import IO;
import Map;
import Map::Extra;
	
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


rel[GProd, GProd] knownSubexpression(map[ExpressionOccurence, set[ExpressionOccurenceLocation]] index) = 
	( {}
	| it + 
		{ <s,r> 
		| n <- index[k]
		, occurenceRule(r) := n
		, m <- index[k]
		, occurenceSubExpr(s) := m
		}
	| k <- index
	, size(index[k]) > 1
	, fullExpr(nonterminal(_)) !:= k);


map[GExpr, set[GProd]] commonSubexpressions(map[ExpressionOccurence, set[ExpressionOccurenceLocation]] index) {
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
	return ( () | addItemToValueSet(addItemToValueSet(it, a, b), a, c) | <a,b,c> <- triples );
}

void duplications(GGrammar theGrammar) {
	map[ExpressionOccurence, set[ExpressionOccurenceLocation]] index = buildExpressionIndex(theGrammar);
	
	set[set[GProd]] duplicateRules = duplicateProductionRules(index);
	rel[GProd,GProd] knownSubs = knownSubexpression(index);
	map[GExpr, set[GProd]] commonSubs= commonSubexpressions(index);	
}