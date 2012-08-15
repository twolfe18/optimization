
import interfaces, dense;

class BacktrackingLineSearch {
	
	uint maxIter;
	double initialStep, decay;
	GradientOpt fun;
	
	this(uint maxIter, double initialStep, double decay, GradientOpt fun) {
		assert(decay < 1.0);
		this.maxIter = maxIter;
		this.initialStep = initialStep;
		this.decay = decay;
		this.fun = fun;
	}
	
	double step(DVec direction) {
		DVec x_old = fun.getParams();
		DVec x = x_old.deepCopy();
		double f_new, f_old = fun.value();
		double alpha = this.initialStep;
		double increase;
		uint iter = 0;
		do {
			x = x_old + (alpha * direction);
			alpha *= this.decay;
			fun.setParams(x);
			f_new = fun.value();
			increase = f_new - f_old;	
		}
		while(increase < 1e-4
			&& iter++ < maxIter
			&& alpha > 1e-9);
		return increase;
	}
	
}

