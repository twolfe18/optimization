
// TODO look up operator overloading for vector[i] notation

abstract class Vector {
	double get(uint index);
	double opCall(uint index) { return get(index); }
	void set(uint index, double val);
	double lpNorm(double p);
	@property {
		ulong dimension();
	}
}

struct Elem {
	uint tag, index;	// tag specifies what feature set it's in
	double value;
	this(uint index, double value) {
		this(0, index, value);
	}
	this(uint tag, uint index, double value) {
		this.tag = tag;
		this.index = index;
		this.value = value;
	}
	@property {
		ulong fullIndex() {
			return ((cast(ulong)tag)<<32) | index;
		}
	}
}

double dot(Vector* a, Vector* b) {
	// dispatch by type
	return -1;
}

