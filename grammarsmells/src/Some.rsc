module Some

import IO;

void main(list[str] argv) {
	println("Hello world");
}

lrel[int,int] foo(lrel[int,int] xs, int n) {
	return [ x | x:<n,_> <- xs];
}