
import std.stdio;
import std.stream;
import std.string;
import std.c.stdlib;
import std.c.stdio;
import std.format;
import parsing, sparse, misc;
 
void mainish() {
	writeln("Hello World!");
  
	uint dimension = cast(uint) 1e9;
	uint i = 0;
	string fname = "/Users/travis/Desktop/test_vec.txt";
	BufferedFile bf = new BufferedFile(fname);
	scope(exit) bf.close;
	while(!bf.eof) {
		char[] line = strip(bf.readLine());
		if(line.length == 0) continue;
		writefln("line = %s", line);
		SVec vec = parseLine(line, dimension, "\t");
	}
}










