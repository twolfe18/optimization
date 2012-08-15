
import misc, dense;

class SVec : Vector {
	Elem[] elems;
	ulong dim;
	
	this(ulong dimension) {
		this.dim = dim;
//		this.elems.length = 20;	// a guess
	}
	
	~this() {
		delete elems;
	}
	
	double get(uint index) {
		return -1;
	}
	
	void set(uint index, double val) {
		
	}
	
	ulong dimension() { return dim; }
	
	double lpNorm(double p) {
		return -1;
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



