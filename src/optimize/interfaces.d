
import dense;

interface GradientOpt {
	DVec getParams();
	void setParams(DVec params);
	double value();
	void gradient(DVec gradient_buf);
}

