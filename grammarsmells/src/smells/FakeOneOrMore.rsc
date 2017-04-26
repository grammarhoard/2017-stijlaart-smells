module smells::FakeOneOrMore

import grammarlab::language::Grammar;
import GrammarUtils;
import Violations;

set[Violation] violations(grammarInfo(grammar(_,ps,_), grammarData(_, _, expressionIndex,_,_), facts)) =
	{ <violatingExpression(a), fakeOneOrMore(a,b,c)>
	| production(lhs,rhs) <- ps
	, <a,b,c> <- fakeOneOrMoreForExpression(rhs) 
	}; 


rel[GExpr, GExpr, GExpr] fakeOneOrMoreForExpression(GExpr e) =
	{ <match, left, right>
	| /match:sequence([*_, left:star(x), right:x, *_]) := e ||
	  /match:sequence([*_, left:x, right:star(x), *_]) := e
	};