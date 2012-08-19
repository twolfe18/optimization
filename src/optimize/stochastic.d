
import interfaces;

class VanillaSGD {
	
	StochasticGradientOpt fun;
	StepSchedule stepSchedule;
	
	void optimize(uint maxiter, double stepScale, uint batchSize) {
		
		DVex x = fun.getParams();
		uint D = x.dimension;
		uint N = fun.numInstances();
		DVec step_buf = new DVec(N);
		
		for(auto iter=0; iter<maxiter; iter++)
			x = iteration(x, step_buf, iter, batchSize, stepScale);
	}
	
	// returns the iterate after taking the step
	ref DVec iteration(ref DVec x, ref DVec step_buf,
		uint iter, uint batchSize, double stepScale) {
		
		uint N = step_buf.dimension;
		fun.setSubset(rand.sample(batchSize, N));
		fun.gradient(step_buf);
		step_buf *= stepScale * stepSchedule.stepAt(iter);
		x += step;
		fun.setParams(x);
		return x;
	}
}

class AveragedSGD : VanillaSGD {
	 
	 void optimize(uint maxiter, double stepScale, uint batchSize) {
	 	uint N = fun.numInstances();
	 	DVec sum_of_iterates = new DVec(N);
	 	for(auto iter=0; iter<maxiter; iter++) {
	 		x = super.iteration(x, step_buf, iter, batchSize, stepScale);
	 		sum_of_iterates += x;
	 	}
	 	sum_of_iterates *= 1.0/maxiter;
	 	fun.setParams(sum_of_iterates);
	 }
	 
}

class AdaptiveSGD {
	
	StochasticGradientOpt fun;
	
	// go read the paper again
}









