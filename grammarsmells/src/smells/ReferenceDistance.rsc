module smells::ReferenceDistance

import grammarlab::language::Grammar;
import GrammarUtils;
import List;
import Set;
import util::Math;
import IO;

alias ReferenceDistanceInfo = 
	tuple[lrel[GProd,int],int]
	;
	 
ReferenceDistanceInfo referenceDistances(GGrammar theGrammar:grammar(_,ps,_)) {
	pairs = [ <p, referenceDistance(theGrammar, p)> | p <- ps];
	int total =  sum([0] + [ x | <_,x> <- pairs]);
	return <pairs,total>;
}

int referenceDistance(GGrammar theGrammar:grammar(_,ps,_), GProd prod) {
	production(lhs, rhs) = prod;
	set[str] ns = GrammarUtils::exprNonterminals(rhs);
	int rhsIndex = indexOf(ps, prod);
	items = [  max(union({{0}, { abs(rhsIndex - indexOf(ps, p))  | p <- prodsForNonterminal(theGrammar, n) }})) | n <- ns ];
	return sum([0] + items);
}

bool jumpsOver(str a, str b, str c, rel[str,str] r) =
	(<a,c> in r && <a,b> notin r) || (<c,a> in r && <c,b> notin r);

list[str] violations(GGrammar theGrammar) {
	list[str] l = orderedLhs(theGrammar);
    rel[str,str] r  = nonterminalReferences(theGrammar);
	rel[str,str] rPlus = r+;
	return [ b | [_*,a,b,c,_*] := l, jumpsOver(a,b,c, rPlus)];
}


