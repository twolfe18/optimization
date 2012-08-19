
import std.stdio;

// 2-way map, similar to Mallet's Alphabet
// to use this, T must implement:
// hash_t toHash()
// bool opEquals(Object)
// int opCmp(Object)

class Bimap(T) {
	
	ulong[T] toIndex;
	T[] toObject;
	
	T get(uint index) {
		if(index >= toObject.length)
			throw new Exception("bad index");
		return toObject[index];
	}
	
	ulong lookup(T obj) {
		auto p = obj in toIndex;
		if(p) return *p;
		throw new Exception("missing element");
	}
	
	ulong lookupOrAdd(T obj) {
		writeln("in lookupOrAdd");
		ulong* p = obj in toIndex;
		if(p) {
			writeln("found p = ", p);
			return *p;
		}
		ulong i = toObject.length;
		toObject ~= obj;
		toIndex[obj] = i;
		return i;
	}
	
	@property ulong length() {
		assert(toObject.length == toIndex.length);
		return toObject.length;
	}
	
}
