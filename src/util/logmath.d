
import std.math;
import std.mathspecial;

const double nifty = -1.0 / 0.0;
double logAdd(double x, double y) {
	if(x < y) {
		double t = x; x = y; y = t;
	}
	if(x == nifty) return nifty;
	return x + log1p(exp(y-x));
}

