module Some

import IO;
import Input;
import smells::UpDownReferences;
import GrammarInformation;

void main(list[str] argv) {
	str cwd = argv[0];
	println("Hello world");
	loc targetPath = |file://<cwd>/input|;
	list[loc] inputFiles = Input::extractedGrammarLocationsInDir(targetPath);
	
	result = [ <l,getReferenceInfo(gInfo)> | l <- inputFiles, gInfo := GrammarInformation::build(l)];
	iprintln(result);
}

lrel[int,int] foo(lrel[int,int] xs, int n) {
	return [ x | x:<n,_> <- xs];
}