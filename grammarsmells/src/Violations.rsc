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
	| fakeZeroOrMore()
	| improperResponsibility()
	| legacyUsage(LegacyUsage u)
	| mixedDefinition()
	| mixedTops()
	| redirectingNonterminal()
	| singleUsageNonterminal(set[GProd] ps)
	| referenceDistanceJumpOver(GProd a, GProd b, GProd c)
	| scatteredNonterminal()
	| singleListThingy(GExpr e)
	| counterDirectionReferencedProduction()
	;
	
data LegacyUsage
	= legacyOptional(str n)
	| legacyPlus(str n)
	| legacyStar(str n)
	;
	
alias Violation = tuple[ViolationLocation, ViolationReason];