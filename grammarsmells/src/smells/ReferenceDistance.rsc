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
	 
ReferenceDistanceInfo referenceDistances(grammarInfo(g:grammar(_,ps,ss), grammarData(r, nprods, _, _, _), _)) {
	pairs = [ <p, referenceDistance(g, p, nprods)> | p <- ps];
	int total =  sum([0] + [ x | <_,x> <- pairs]);
	return <pairs,total>;
}

int referenceDistance(GGrammar theGrammar:grammar(_,ps,_), GProd prod, map[str, set[GProd]] nprods) {
	production(lhs, rhs) = prod;
	set[str] ns = GrammarUtils::exprNonterminals(rhs);
	int rhsIndex = indexOf(ps, prod);
	items = [  max(union({{0}, { abs(rhsIndex - indexOf(ps, p))  | nprods[n]?, p <- nprods[n] }})) | n <- ns ];
	return sum([0] + items);
}

bool jumpsOver(str a, str b, str c, rel[str,str] r) =
	(<a,c> in r && <a,b> notin r) || (<c,a> in r && <c,b> notin r);

list[str] violations(grammarInfo(g, grammarData(r, _, expressionIndex, tops, _), _)) {
	list[str] l = orderedLhs(g);
	rel[str,str] rPlus = r+;
	return [ b | [_*,a,b,c,_*] := l, jumpsOver(a,b,c, rPlus)];
}


