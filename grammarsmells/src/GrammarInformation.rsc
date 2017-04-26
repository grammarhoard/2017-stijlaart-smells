module GrammarInformation

import grammarlab::language::Grammar;
import GrammarUtils;
import Set;

alias ExpressionIndex = map[ExpressionOccurence, set[ExpressionOccurenceLocation]];
alias Facts = map[FactProperty, bool];

data GrammarData
	= grammarData(
		rel[str,str] references,
		map[str, set[GProd]] nprods,
		ExpressionIndex exprIndex,
		set[str] tops,
		set[str] bottoms
	  );
	  
anno rel[str,str] GrammarData @ references;

data FactProperty 
	= containsStar()
	| containsPlus()
	| containsOptional()
	;
	
data GrammarInfo
	= grammarInfo(
		GGrammar g,
		GrammarData d,
		Facts facts
	  );


bool containsStarFact(grammarData(_,_,index,_,_))
	= any( k <- index
		 , fullExpr(l) := k
		 , star(_) := l
		 );

bool containsPlusFact(grammarData(_,_,index,_,_))
	= any( k <- index
		 , fullExpr(l) := k
		 , plus(_) := l
		 );

bool containsOptionalFact(grammarData(_,_,index,_,_))
	= any( k <- index
		 , fullExpr(l) := k
		 , optional(_) := l
		 );
	
GrammarInfo build(GGrammar theGrammar) {
	map[str, set[GProd]] nprods = nonterminalProdMap(theGrammar);

	GrammarData d = grammarData(
		nonterminalReferencesWithProdMap(theGrammar, nprods),
		nprods,
		buildExpressionIndex(theGrammar),
		grammarTops(theGrammar),
		grammarBottoms(theGrammar)
	);
	
	return grammarInfo(
		theGrammar,
		d,
		( containsStar() : containsStarFact(d)
		, containsPlus() : containsPlusFact(d)
		, containsOptional() : containsOptionalFact(d)
		)
	);
}


rel[str,str] references(grammarData(r,_,_,_,_)) =
	r;
