
import probability;
import std.stdio;

int alltests() {
	
	writeln("running probtests...");
	
	auto p1 = new LogProb(-1.0);
	
	// need some examples to get the semantics right...
	LogProb[] weights;	// log weights
	
	immutable uint K = 10;
	weights.length = K;
	for(ulong i=0; i<K; i++) {
		
		LogProb p_z = LogProb(-0.5);
		LogProb p_w = LogProb(-2.5);
		
		assert(p_z > p_w);
		
		weights[i] = p_z * p_w;
	}
	
	writeln("everything looks good!");
	return 1;
}

