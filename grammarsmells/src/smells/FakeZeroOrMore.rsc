module smells::FakeZeroOrMore


import IO;
import grammarlab::language::Grammar;
import GrammarUtils;
import List;
import Set;
import Relation;

set[GExpr] fakeZeroOrMoreForExpression(GExpr e) {
	set[GExpr] answer = {};
	//TODO This pattern match is not good I think
	for (optional(plus(_)) := e) {
		answer += e;
	}
	return answer;
}

set[GExpr] fakeZeroOrMore(grammar(_,ps,_)) =
	( {}
	| it + fakeZeroOrMoreForExpression(rhs)
	| production(lhs,rhs) <-ps
	);