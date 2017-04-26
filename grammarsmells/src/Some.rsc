module Some

import IO;

int main(list[str] argv) {
	println("Hello world");
	return 0;
}

lrel[int,int] foo(lrel[int,int] xs, int n) {
	return [ x | x:<n,_> <- xs];
}