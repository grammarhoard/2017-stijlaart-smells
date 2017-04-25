module smells::FakeZeroOrMore


import IO;
import grammarlab::language::Grammar;
import GrammarUtils;
import List;
import Set;
import Relation;

set[GExpr] fakeZeroOrMoreForExpression(GExpr e) {
	set[GExpr] answer = {};
	for (optional(plus(_)) := e) {
		answer += e;
	}
	return answer;
}

set[GExpr] fakeZeroOrMore(GGrammar theGrammar) {
	grammar(_,ps,_) = theGrammar;
	
	set[GExpr] result = ( {} | it + fakeZeroOrMoreForExpression(rhs) | production(lhs,rhs) <-ps ); 
	return result;
}