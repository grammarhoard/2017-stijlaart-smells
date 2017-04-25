module GrammarUtils

import grammarlab::language::Grammar;
import IO;
import Set;
import Relation;
import Map::Extra;


data ExpressionOccurence
	= fullExpr(GExpr expr2)
	| partialExpr(list[GExpr] exprs)
	;

data ExpressionOccurenceLocation
	= occurenceRule(GProd p)
	| occurenceSubExpr(GProd p)
	| occurencePartial(GProd p)
	;
	
map[ExpressionOccurence, set[ExpressionOccurenceLocation]] buildExpressionIndex(grammar(_,ps,_)) =
	( () | registerExpressionsForProd(it, prod) | prod <- ps);	

map[ExpressionOccurence, set[ExpressionOccurenceLocation]] registerExpressionsForProd(map[ExpressionOccurence, set[ExpressionOccurenceLocation]] index, production(lhs, expr)) {
	index = addItemToValueSet(index, fullExpr(expr), occurenceRule(production(lhs, expr)));
	
	int counter = 0;
	visit (expr) {
		case GExpr v: { 
			if (!(v == expr) ) {
				index = addItemToValueSet(index, fullExpr(v), occurenceSubExpr(production(lhs, expr)));
				counter += 1;
			}
		}
	}
	return index;
}

set[set[&T]] partitionForTransitiveClosure(rel[&T,&T] input) {
	rel[&T,&T] inputClosure = input+;
	set[set[&T]] partitions = {};
	set[&T] done = {};
	
	for (n <- (domain(inputClosure) + range(inputClosure)), n notin done) {
		set[&T] nextLevel = 
			{ n } + { y | <x,y> <- domainR(inputClosure, {n})
						, <y,x> in inputClosure 
					};
		done += nextLevel;
		partitions = partitions + {nextLevel};
	}
	return partitions;
}

set[set[str]] languageLevels(GGrammar theGrammar) {
	grammar(ns,_,_) = theGrammar;
	rel[str,str] referencesClosure = nonterminalReferences(theGrammar)+;
	return partitionForTransitiveClosure(referencesClosure);
	//set[set[str]] levels = {};
	//set[str] done = {};
	//
	//for (n <- ns, n notin done) {
	//	set[str] nextLevel = 
	//		{ n } + { y | <x,y> <- domainR(referencesClosure, {n})
	//					, <y,x> in referencesClosure 
	//				};
	//	done = nextLevel;
	//	levels = levels + {nextLevel};
	//	
	//}
	//return levels;
}

set[str] exprNonterminals(GExpr expr) {
	set[str] result = {};
	visit (expr) {
		case nonterminal(t): result = result + t;
	}
	return result;
}

map[str, set[GProd]] nonterminalProdMap(grammar(ns, ps, ss)) =
	( n : prodsForNonterminal(grammar(ns,ps,ss), n) | n <- ns);
	
set[GProd] prodsForNonterminal(grammar(_,ps,_), str n) =
	{ p | p <- ps , production(m,_) := p, n == m};


lrel[GProd, str] prodReferences(grammar(_,ps,_)) {
	return [ <production(lhs,rhs), n> | production(lhs,rhs) <- ps, n <- exprNonterminals(rhs)];
}


rel[str,str] nonterminalReferences(GGrammar theGrammar ) { 
	grammar(ns,ps,_) = theGrammar;	
	return { <n,m> | n <- ns, production(_,e) <- prodsForNonterminal(theGrammar, n), m <- exprNonterminals(e)};
}

list[str] orderedLhs(grammar(_,ps,_)) =
	[ lhs | production(lhs,_) <- ps];