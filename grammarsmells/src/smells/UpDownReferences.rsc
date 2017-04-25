module smells::UpDownReferences

import grammarlab::language::Grammar;
import GrammarUtils;
import List;
import Set;
import IO;
import util::Math;

data ReferenceInfo =
 referenceInfo(int up, int down, ReferenceDir dir, real ratio);

alias ProdReferences = tuple[GProd p, int up, int down];

data ReferenceDir
	= upReferencing()
	| downReferencing()
	| balanced()
	;
	
tuple[int,int] addReferences(<xUp, xDown> , <_, yUp, yDown>) =
	 <xUp + yUp, xDown + yDown>;

set[GProd] violations(GGrammar theGrammar) {
	grammar(_,ps,_) = theGrammar;
	ReferenceInfo prodR = getReferenceInfo(theGrammar);
	iprintln(prodR);
	
	set[GProd] upAndDowns = { p | p <- ps, <_,up, down> := prodReference(theGrammar, p), up > 0 && down > 0};
	iprintln(size(upAndDowns));
	//TODO Bring back
	//set[GProd] violations = { p | p <- upAndDowns, canMutateToReduceRatio(theGrammar, prodR, p) };
	set[set[str]] levels = languageLevels(theGrammar);

	list[list[GProd]] groupedByLevel = groupProductionsByLevel(ps, levels);
	list[set[str]] groupedByLevelNs = [ { lhs | production(lhs,_) <- group } | group <- groupedByLevel ];
	
	for ( [_*, a, _*, b, _*, c, _*] := groupedByLevelNs) {
		set[str] aLevel = levelFor(a, levels);
		set[str] bLevel = levelFor(b, levels);
		set[str] cLevel = levelFor(c, levels);
		if (aLevel == cLevel && aLevel != bLevel) {
			iprintln("Violation <a> <b> <c>");
		}
	}
	return violations;
}

set[str] levelFor(set[str] items, set[set[str]] levels) = 
	getOneFrom({ level | level <- levels, items <= level })
	; 


list[list[GProd]] groupProductionsByLevel(list[GProd] prods, set[set[str]] levels) {
	list[list[GProd]] result = [];
	list[GProd] next = take(1, prods);
	list[GProd] rest = drop(1, prods);
	
	for (p <- rest) {
		production(lastLhs, _) = last(next);
		production(lhs,rhs) = p;
		if (size({ level | level <- levels, lhs in level && lastLhs in level }) == 0) {
			result += [next];
	 		next = [p];
		} else {
			next += [p];
		}
	}
	result += [next];
	return result;
}

int MOVE_DISTANCE = 5;

bool canMutateToReduceRatio(GGrammar theGrammar, ReferenceInfo currentReferenceInfo, GProd prod) {
	iprintln("canMutateToReduceRatio <currentReferenceInfo>");
	grammar(ns,ps,ss) = theGrammar;
	int current = indexOf(ps, prod);
	list[list[GProd]] perms =  movesOfElementInDistance(ps, current, MOVE_DISTANCE);
	return any(perm <- perms, isMoreExtreme(getReferenceInfo(grammar(ns, perm, ss)), currentReferenceInfo)); 
}

bool isMoreExtreme(referenceInfo(_, _, _, aRatio), referenceInfo(_ ,_ ,_ , bRatio)) =
	aRatio > bRatio;

list[list[&T]] movesOfElementInDistance(list[&T] input, int index, int distance) {
	list[int] positions = insertPositions(index, size(input), distance);
	return [ List::insertAt( List::delete(input, index), p, input[index]) | p <- positions ];  
}
list[int] insertPositions(int current, int length, int distance) {	
	return [x | x <- [(current-distance)..(current + distance + 1)], x != current, x >= 0, x <= length ];
} 

ReferenceInfo getReferenceInfo(GGrammar theGrammar) {
	grammar(_,ps,_) = theGrammar;
	<up,down> = ( <0,0> | addReferences(it, prodReference(theGrammar,p)) | p <- ps);
	int diff = abs(up - down);
	real ratio = diff == 0 ? 0.0 : (diff / 1.0) / (up + down);
	iprintln(ratio);
	return 
		referenceInfo(
			  up
			, down
			, up == down ? balanced() : (up < down ? downReferencing() : upReferencing())
			, ratio
		);
} 


ProdReferences prodReference(GGrammar theGrammar, GProd p) {
	grammar(_,ps,_) = theGrammar;
	production(lhs, rhs) = p;
	
	set[str] ns = exprNonterminals(rhs);
	int pIndex = indexOf(ps,p);
	int down = 0;
	int up = 0;

	for(n <- ns) {
		otherPIndices = {indexOf(ps, otherP) | otherP <- prodsForNonterminal(theGrammar, n)};
		if ( !isEmpty({ i | i <- otherPIndices, pIndex < i})) {
			down +=1;
		} 
		if ( !isEmpty({ i | i <- otherPIndices, pIndex > i})) {
			up +=1;
		} 
	}  
	return <p, up, down>;
}

