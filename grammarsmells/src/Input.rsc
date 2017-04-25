module Input

import IO;

list[loc] extractedGrammarLocationsForFile(loc f) {
	if (isDirectory(f)) {
		if (/extracted$/ := f.path) {
			return [f + "/grammar.bgf"];
		} else {
			return extractedGrammarLocationsInDir(f);
		}
	} else {
	 	return [];
	}
}
			
list[loc] extractedGrammarLocationsInDir(loc targetDir) {
	list[value] res;
	return ( [] | it + extractedGrammarLocationsForFile(f) | loc f <- targetDir.ls);
}

