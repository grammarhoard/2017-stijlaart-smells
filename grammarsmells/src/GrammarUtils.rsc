module GrammarUtils

import grammarlab::language::Grammar;
import IO;
import Set;
import Relation;
import Map::Extra;
import List;
import Map;
data ExpressionOccurence
	= fullExpr(GExpr expr2)
	| partialExpr(list[GExpr] exprs)
	;

data ExpressionOccurenceLocation
	= occurenceRule(GProd p)
	| occurenceSubExpr(GProd p)
	| occurencePartial(GProd p)
	;
	
map[ExpressionOccurence, list[ExpressionOccurenceLocation]] buildExpressionIndex(grammar(_,ps,_)) =
	( () | registerExpressionsForProd(it, prod) | prod <- ps);	

map[ExpressionOccurence, list[ExpressionOccurenceLocation]] registerExpressionsForProd(map[ExpressionOccurence, list[ExpressionOccurenceLocation]] index, production(lhs, expr)) {
	index = addItemToValueList(index, fullExpr(expr), occurenceRule(production(lhs, expr)));
	
	int counter = 0;
	visit (expr) {
		case GExpr v: { 
			if (!(v == expr) ) {
				index = addItemToValueList(index, fullExpr(v), occurenceSubExpr(production(lhs, expr)));
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

set[set[str]] languageLevels(GGrammar g) =
	partitionForTransitiveClosure(nonterminalReferences(g)+);

set[str] exprNonterminals(GExpr expr) {
	set[str] result = {};
	visit (expr) {
		case nonterminal(t): result = result + t;
	}
	return result;
}

map[str, set[GProd]] nonterminalProdMap(g:grammar(ns, ps, ss)) =
	( n : prodsForNonterminal(g, n) | n <- ns);
	
set[GProd] prodsForNonterminal(grammar(_,ps,_), str n) =
	{ p | p <- ps , production(n,_) := p};


lrel[GProd, str] prodReferences(grammar(_,ps,_)) {
	return [ <production(lhs,rhs), n> | production(lhs,rhs) <- ps, n <- exprNonterminals(rhs)];
}

rel[str,str] nonterminalReferencesWithProdMap(GGrammar g:grammar(ns,_,_), map[str, set[GProd]] nprods) = 
	{ <n,m>
	| n <- ns
	, production(_,e) <- nprods[n]
	, m <- exprNonterminals(e)
	};
	
rel[str,str] nonterminalReferences(GGrammar g) =
	nonterminalReferencesWithProdMap(g, nonterminalProdMap(g));


list[str] orderedLhs(grammar(_,ps,_)) =
	[ lhs | production(lhs,_) <- ps];
	
set[str] grammarTops(GGrammar g:grammar(ns,_,_)) =
	toSet(ns) - range(nonterminalReferences(g));

set[str] grammarBottoms(GGrammar g:grammar(ns,_,_)) =
	range(nonterminalReferences(g)) - toSet(ns);
