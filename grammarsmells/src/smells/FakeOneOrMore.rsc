module smells::FakeOneOrMore


import IO;
import grammarlab::language::Grammar;
import GrammarUtils;
import List;
import Set;
import Relation;


set[tuple[GExpr, GExpr, GExpr]] fakeOneOrMoreForExpression(GExpr e) {
	set[tuple[GExpr, GExpr, GExpr]] answer = {};
	for (/match:sequence([*_, left:star(x), right:x, *_]) := e || /match:sequence([*_, left:x, right:star(x), *_]) := e) {
		answer += <match, left, right>;
	}
	return answer;
}

set[tuple[GExpr, GExpr, GExpr]] voilations(grammarInfo(grammar(_,ps,_), grammarData(_, _, expressionIndex,_,_), facts)) =
	( {}
	| it + fakeOneOrMoreForExpression(rhs)
	| production(lhs,rhs) <-ps
	); 
