
import std.math;
import sample, probability;

struct Counts {
	uint[] counts;
	ulong sum;
	void inc(uint index) {
		assert(counts[index] <= sum);
		counts[index]++;
		sum++;
	}
	void dec(uint index) {
		assert(counts[index] >= 0);
		counts[index]--;
		sum--;
	}
	@property ulong dimension() {
		return counts.length;
	}
}

class LDA {

	struct Doc {
		uint[] w;
		uint[] z;
		Counts N_z;
		@property ulong length() {
			assert(w.length == z.length);
			return w.length;
		}
	}	
	
	uint numTopics;
	Counts[] phi_ss;
	Doc[] docs;
	double alpha, beta;	// dirichlet priors on topic and word distributions respectively
	
	void sample(uint iterations) {
		for(auto iter=0; iter<iterations; iter++)
			foreach(Doc d; docs)
				for(auto i=0; i<d.length; i++)
					sample(d, i);
	}
	
	LogProb dirichletMultinomialProb(uint index, Counts ss, double dirichletPrior) {
		double num = ss.counts[index] + dirichletPrior;
		double denom = ss.sum + ss.dimension * dirichletPrior;
		return LogProb(log(num)-log(denom));
	}
	
	void sample(Doc doc, int i) {
		uint z_old = doc.z[i];
		uint w = doc.w[i];
		doc.N_z.dec(z_old);
		phi_ss[z_old].dec(w);
		
		LogProb[] weights;
		weights.length = numTopics;
		for(uint t=0; t<numTopics; t++) {
			LogProb p_z = dirichletMultinomialProb(t, doc.N_z, alpha);
			LogProb p_w = dirichletMultinomialProb(w, phi_ss[t], beta);
			weights[t] = p_w * p_z;
		}
		
		uint z_new = cast(uint) logChoice(weights);
		doc.N_z.inc(z_new);
		phi_ss[z_new].inc(w);
	}

	// TODO
	// - train and test
	// - likelihood
	
}






