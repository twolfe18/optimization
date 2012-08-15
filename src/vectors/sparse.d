
import misc, dense;
import std.math;

class SVec : Vector {
	Elem[] elems;
	ulong dim;
	
	this(ulong dimension) {
		this.dim = dim;
//		this.elems.length = 20;	// a guess
	}
	
	// you can only free memory if you somehow allocated it explicitly
	// TODO read up on this...
//	~this() {
//		delete elems;
//	}
	
	double get(uint index) {
		foreach(Elem e; elems)
			if(e.index == index)
				return e.value;
		return 0.0;
	}
	
	void set(uint index, double val) {
		foreach(uint i, Elem e; elems) {
			if(e.index == index) {
				e.value = val;
				return;
			}
		}
		throw new Exception("haven't added support for adding a new index yet");
	}
	
	ulong dimension() { return dim; }
	
	double lpNorm(double p) {
		double s = 0.0;
		foreach(Elem e; elems)
			s += pow(e.value, p);
		return pow(s, 1/p);
	}
}

class LSVec : SVec {
	int label;
	this(int lable, uint dimension) {
		this.label = label;
		super(dimension);
	}
}

double sd_dot(SVec* a, DVec* b) {
	assert(a.dimension == b.dimension);
	double s = 0.0;
	foreach(Elem e; a.elems)
		s += e.value * b.get(e.index);
	return s;
}

double ss_dot(SVec* a, SVec* b) {
	assert(a.dimension == b.dimension);
	double d = 0.0;
	int a_ptr = 0;
	foreach(Elem e; b.elems) {
		ulong target = e.fullIndex();
		Elem o;
		do {
			o = a.elems[a_ptr];
			a_ptr++;
		} while(o.fullIndex() < target);
		if(o.fullIndex == target)
			d += o.value * e.value;
		if(a_ptr > a.elems.length)
			break;
	}
	return d;
}



