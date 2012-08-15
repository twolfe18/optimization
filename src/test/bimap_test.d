
import std.stdio;
import std.string;
import bimap;

class Foo {
	uint bar, baz;
	this(uint bar, uint bas) {
		this.bar = bar;
		this.baz = baz;
	}
	hash_t toHash() {
		return bar ^ baz;
	}
	bool opEquals(Object other) {
		Foo o = cast(Foo) other;
		if(o is null) return false;
		return bar == o.bar && baz == o.baz;
	}
}

int alltests() {
	writeln("testing bimap...");
	stringTest();
	fooTest();
	writeln("everything looks good!");
	return 1;
}

void fooTest() {
	auto map = new Bimap!(Foo);
	ulong i1 = map.lookupOrAdd(new Foo(1, 2));
	assert(i1 == 0, format("i1 = %d", i1));
	assert(map.length == 1);
	assert(map.get(0) == new Foo(1, 2));
	
	ulong i2 = map.lookupOrAdd(new Foo(2, 1));
	assert(i2 == 1, format("i2 = %d", i2));
	assert(map.length == 2);
	assert(map.get(1) == new Foo(2, 1));
}

void stringTest() {
	auto map = new Bimap!(string);
	
	ulong i1 = map.lookupOrAdd("first string");
	assert(i1 == 0, format("i1 = %d", i1));
	assert(map.length == 1);
	
	ulong i2 = map.lookupOrAdd("second string");
	assert(i2 == 1, format("i2 = %d", i2));
	assert(map.length == 2);
	
	i1 = map.lookupOrAdd("first string");
	assert(i1 == 0, format("i1 = %d", i1));
	assert(map.length == 2);
	
	i1 = map.lookup("first string");
	assert(i1 == 0, format("i1 = %d", i1));
	assert(map.length == 2);
	
	i2 = map.lookup("second string");
	assert(i2 == 1, format("i2 = %d", i2));
	assert(map.length == 2);
	
	try {
		ulong i3 = map.lookup("third string");
		assert(false, "should have thrown exception");
	} catch(Exception e) {}
	
	assert(map.get(0) == "first string");
	assert(map.get(1) == "second string");
	try {
		map.get(2);
		assert(false, "should have thrown exception");
	} catch(Exception e) {}
}


