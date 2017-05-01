module output::UpDownReferences

import Violations;
import GrammarInformation;
import IO;
import smells::UpDownReferences;
import lang::json::IO;
import List;

void export(list[tuple[loc, GrammarInfo]] input) {
	lrel[loc,ReferenceInfo] referenceInfos = [<l, getReferenceInfo(gInfo)> | <l,gInfo> <- input];
	iprintln(totalStats(referenceInfos));
	list[value] x = [referenceInfoJson(l, i) | <l,i> <- referenceInfos];
	IO::writeFile(|project://grammarsmells/output/reference-info.json|, toJSON(x, true));
}

value totalStats(lrel[loc,ReferenceInfo] referenceInfos) {
	int downs = size([ i | <a, i> <- referenceInfos, referenceInfo(_,_,downReferencing(),_) := i ]);
	int ups = size([ i | <a, i> <- referenceInfos, referenceInfo(_,_,upReferencing(),_) := i ]);
	int evens = size([ i | <a, i> <- referenceInfos, referenceInfo(_,_,evenReferencing(),_) := i ]); 
	return
		( "downs": downs
		, "ups" : ups
		, "evens": evens
		);
} 

value referenceInfoJson(loc l, ReferenceInfo i:referenceInfo(up,down,dir,ratio)) =
	( "location" : "<l>"
	, "up" : up
	, "down" : down
	, "dir" : dir == downReferencing() ? "DOWN" : dir == upReferencing() ? "UP" : "EVEN"
	, "ratio" : ratio
	);