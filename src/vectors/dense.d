
import misc;
import std.math;

// TODO look up vector ops in D

class DVec : Vector {
	double[] vals;
	
	this(ulong dimension) {
		//this.vals = double[];
//		this.vals = double[];
		this.vals.length = dimension;
	}
	
//	~this() {
//		delete vals;
//	}
	
	double get(uint index) {
		assert(index >= 0 && index < vals.length);
		return vals[index];
	}
	
	void set(uint index, double val) {
		assert(index >= 0 && index < vals.length);
		vals[index] = val;
	}
	
	ulong dimension() { return vals.length; }
	
	double lpNorm(double p) {
		double x = 0.0;
		foreach(double v; vals)
			x += pow(v, p);
		return pow(x, 1/p);
	}
	
	DVec deepCopy() {
		DVec result = new DVec(this.dimension);
		for(uint i=0; i<vals.length; i++)
			result.vals[i] = vals[i];
		return result;
	}
	
	DVec opBinary(string op)(DVec rhs) {
		assert(this.dimension == rhs.dimension);
		DVec result = new DVec(this.dimension);
		for(uint i=0; i<vals.length; i++)
			mixin("result.vals[i] = vals[i] "~op~" rhs.vals[i];");
		return result;
	}
	
	DVec opBinary(string op)(double rhs) {
		DVec result = new DVec(this.dimension);
		for(uint i=0; i<vals.length; i++)
			mixin("result.vals[i] = vals[i] "~op~"rhs;");
		return result;
	}
	
	DVec opBinaryRight(string op)(double rhs) {
		static if(op == "+" || op == "*")
			return opBinary!(op)(rhs);
		else static if(op == "-" || op == "/")
			return rhs.opBinary!(op)(this);
		else static
			assert(0, "Operator "~op~" not implemented");
	}
	
	void opOpAssign(string op)(DVec rhs) {
		assert(this.dimension == rhs.dimension);
		for(uint i=0; i<vals.length; i++)
			mixin("vals[i] "~op~"= rhs.vals[i];");
	}
	
	void opOpAssign(string op)(double rhs) {
		for(uint i=0; i<vals.length; i++)
			mixin("vals[i] "~op~"= rhs;");
	}

}

double dd_dot(DVec* a, DVec* b) {
	assert(a.dimension == b.dimension);
	double d = 0.0;
	for(int i=0; i<a.dimension; i++)
		d += a.get(i) * b.get(i);
	return d;
}

