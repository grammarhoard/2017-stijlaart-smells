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

anno LanguageLevels GrammarData @ levels;


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
	

data LanguageLevels =
	languageLevels(set[set[str]] partitions, rel[set[str],set[str]] partitionRel);
	
GrammarInfo build(loc l) {
	GGrammar theGrammar = grammarlab::io::read::BGF::readBGF(l);
		
	map[str, set[GProd]] nprods = nonterminalProdMap(theGrammar);
	rel[str,str] refs = nonterminalReferencesWithProdMap(theGrammar, nprods);
	set[set[str]] partitions = partitionForTransitiveClosure(refs);
	rel[set[str],set[str]] partitionRel = { <x,y> | x <- partitions, y <- partitions, any(m <- x, n <- y, <m,n> in refs)};
	
	LanguageLevels ll = languageLevels(partitions, partitionRel);
	 
	GrammarData d = grammarData(
		refs,
		nprods,
		buildExpressionIndex(theGrammar),
		grammarTops(theGrammar),
		grammarBottoms(theGrammar)
	);
	
	d@levels = ll;
	
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
