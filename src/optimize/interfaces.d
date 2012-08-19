
import dense;

interface OptFunction {
	DVec getParams();
	void setParams(DVec params);
}

interface GradientOpt : OptFunction {
	double value();
	void gradient(DVec gradient_buf);
}

interface StochasticGradientOpt : GradientOpt {
	uint numInstances();
	void setSubset(int[] indices);
}

interface StepSchedule {
	double stepAt(uint epoch);
}
