module Violations

import grammarlab::language::Grammar;


data ViolationLocation
	= violatingNonterminal(str n)
	| violatingNonterminals(set[str] ns)
	| violatingExpression(GExpr expr)
	| violatingExpressions(list[GExpr] exprs)
	| violatingProduction(GProd prod)
	| violatingProductions(set[GProd] prods)
	;
	
data ViolationReason
	= disconnectedFromTop()
	| duplicateRules()
	| definedSubExpression(GExpr e, GProd haystack, GProd needle)
	| commonSubExpression(GExpr e)
	| unclearEntryPoint()
	| fakeOneOrMore(GExpr e1, GExpr e2, GExpr e3)
	;
	
alias Violation = tuple[ViolationLocation, ViolationReason];