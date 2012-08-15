
import std.string;
import std.c.stdlib;
import misc, sparse;
import std.stdio;

Elem parseElem(char[] tok) {
	char[][] kv = split(tok, ":");
	int index, tag = 0;
	double value;
	std.c.stdio.sscanf(cast(const char*) tok, "%d:%f", &index, &value);
	return Elem(tag, index, value);
}

LSVec parseLine(char[] line, uint dim, string delim) {
	LSVec vec = new LSVec(1, dim);
	char[][] toks = split(line, delim);
	vec.elems = new Elem[toks.length-1];
	foreach(int i, char[] t; toks) {
		if(i == 0)
			vec.label = atoi(cast(const char*) t);
		else
			vec.elems[i-1] = parseElem(t);
	}
	return vec;
}





