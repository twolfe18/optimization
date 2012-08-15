
import interfaces, dense;

class BacktrackingLineSearch {
	
	double initialStep, decay;
	GradientOpt fun;
	
	this(double initialStep, double decay, GradientOpt fun) {
		assert(decay < 1.0);
		this.initialStep = initialStep;
		this.decay = decay;
		this.fun = fun;
	}
	
	double step(DVec[] direction) {
		DVec x_old = fun.getParams();
		DVec x = x_old.deepCopy();
		double f_new, f_old = fun.value();
		double alpha = this.initialStep;
		
		do {
			
//			x = x_old + (alpha * direction);
			x = x_old + (direction * alpha);
			alpha *= this.decay;
			fun.setParams(x);
			f_new = fun.value();
			
		} while(f_new - f_old < 1e-4);
		
		return alpha;
	}
	
}

