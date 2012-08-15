
import std.random;
import probability, logmath;
import std.math;
import std.mathspecial;

// NOTE: these could be written with Probabilities instead of doubles
// but it would be less efficient due to the upconversion to LogProb

ulong choice(RegProb[] probs) {
	double sum = 0.0;
	foreach(RegProb p; probs) sum += p.prob;
	return choice(probs, sum);
}

ulong choice(RegProb[] probs, double sum) {
	double cutoff = sum * uniform(0.0, 1.0);
	double partial = 0.0;
	foreach(ulong i, RegProb p; probs) {
		partial += p.prob;
		if(partial >= cutoff)
			return i;
	}
	throw new Exception("check for NaNs");
}

ulong logChoice(LogProb[] logprobs) {
	double logsum = logmath.nifty;
	foreach(LogProb lp; logprobs)
		logsum = logAdd(logsum, lp.logprob);
	return logChoice(logprobs, logsum);
}

ulong logChoice(LogProb[] logprobs, double logsum) {
	double cutoff = logsum + log(uniform(0.0, 1.0));
	double partial = logmath.nifty;
	foreach(ulong i, LogProb lp; logprobs) {
		partial = logAdd(partial, lp.logprob);
		if(partial >= cutoff)
			return i;
	}
	throw new Exception("check for NaNs");
}


//ulong logSample(LogProb[] logprobs, LogProb logsum) {
//	LogProb cutoff = logsum + LogProb(log(uniform(0.0, 1.0)));
//	LogProb partial = LogProb(logmath.nifty);
//	foreach(ulong i, LogProb lp; logprobs) {
//		partial = partial + lp;
//		if(partial.logprob >= cutoff.logprob)
//			return i;
//	}
//	throw new Exception("check for NaNs");
//}





