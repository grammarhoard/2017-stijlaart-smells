module GrammarInformation

import grammarlab::io::read::BGF;
import grammarlab::language::Grammar;
import GrammarUtils;
import Set;
import IO;
import Map;

//TODO: Shouldt this be a list[T] as map value type?
alias ExpressionIndex = map[ExpressionOccurence, list[ExpressionOccurenceLocation]];
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
	| containsChoice()
	| containsSequence()
	| containsEpsilon()
	;
	
data GrammarInfo
	= grammarInfo(
		GGrammar g,
		GrammarData d,
		Facts facts
	  );


bool containsStarFact(grammarData(_,_,index,_,_))
	= any( k <- index
		 , fullExpr(star(_)) := k
		 );

bool containsPlusFact(grammarData(_,_,index,_,_)) 
	= any( k <- index
		 , fullExpr(plus(_)) := k
		 );

bool containsOptionalFact(grammarData(_,_,index,_,_))
	= any( k <- index
		 , fullExpr(optional(_)) := k
		 );
		 
bool containsChoiceFact(grammarData(_,_,index,_,_))
	= any( k <- index
		 , fullExpr(choice(_)) := k 		 
		 );

bool containsSequenceFact(grammarData(_,_,index,_,_))
	= any( k <- index
		 , fullExpr(sequence(_)) := k
		 );
		 
 bool containsEpsilonFact(grammarData(_,_,index,_,_))
	= any( k <- index
		 , fullExpr(epsilon()) := k
		 );
	
GrammarInfo build(loc l) {
	GGrammar theGrammar = grammarlab::io::read::BGF::readBGF(l);
		
	map[str, set[GProd]] nprods = nonterminalProdMap(theGrammar);

	GrammarData d = grammarData(
		nonterminalReferencesWithProdMap(theGrammar, nprods),
		nprods,
		buildExpressionIndex(theGrammar),
		grammarTops(theGrammar),
		grammarBottoms(theGrammar)
	);
	
	facts =( containsStar() : containsStarFact(d)
		, containsPlus() : containsPlusFact(d)
		, containsOptional() : containsOptionalFact(d)
		, containsChoice() : containsChoiceFact(d)
		, containsSequence() : containsSequenceFact(d)
		, containsEpsilon() : containsEpsilonFact(d)
		);
	return grammarInfo(
		theGrammar,
		d,
		facts
	);
}


rel[str,str] references(grammarData(r,_,_,_,_)) =
	r;
