
import std.math;
import std.mathspecial;
import std.random;
import logmath;

alias Probability!(true)  LogProb;
alias Probability!(false) RegProb;

struct Probability(bool logspace) {
	
	double val;
	
	// always pass this a value that is appropriate for the template type
	this(double v) {
		this.val = v;
	}
	
	@property double prob() {
		static if(logspace) return exp(val);
		else return val;
	}
	
	@property double logprob() {
		static if(logspace) return val;
		else return log(val);	
	}
	
	// TODO work double types into operator overloading
	
	// choice 1 (o-times):
	//		->A. promote all o-times expressions to LogProb
	//		  B. allow RegProb = RegProb * RegProb, everything else is promoted to LogProb
	// choice 2 (o-plus):
	//		  A. use the LHS type for mixed o-plus expressions, same type expressions stay as is
	//		->B. promote mixed type o-plus expressions to RegProb

	// binary ops *************************************************************
	// multiply
	LogProb opBinary(string op)(Probability rhs) if(op == "*") { return LogProb(logprob + rhs.logprob); }
	
	// divide
	LogProb opBinary(string op)(Probability rhs) if(op == "/") { return LogProb(logprob - rhs.logprob); }
	
	// add
	LogProb opBinary(string op)(LogProb rhs) if(op == "+" &&  logspace) { return LogProb(logAdd(val, rhs.val));    }		// maybe ban this expression
	RegProb opBinary(string op)(LogProb rhs) if(op == "+" && !logspace) { return RegProb(prob + rhs.prob);         }
	RegProb opBinary(string op)(RegProb rhs) if(op == "+")              { return RegProb(prob + rhs.prob);         }
	
	// subtract
	LogProb opBinary(string op)(LogProb rhs) if(op == "-" &&  logspace) { return LogProb(log(this.prob - rhs.prob)); }		// maybe ban this expression
	RegProb opBinary(string op)(LogProb rhs) if(op == "-" && !logspace) { return RegProb(prob - rhs.prob);           }
	RegProb opBinary(string op)(RegProb rhs) if(op == "-")              { return RegProb(prob - rhs.prob);           }
	
	
	// comparisons ************************************************************
	int opCmp(Probability rhs) {
		double thisval = val;
		double thatval;
		static if(logspace) thatval = rhs.logprob;
		else thatval = rhs.prob;
		if(thisval > thatval) return 1;
		else if(thisval < thatval) return -1;
		return 0;
	}
	
	// opAssignment ***********************************************************
	// TODO
}

// return type must be fully templated-out... have to choose log or not
// may not need this function...
//Probability frac(double numerator, double denominator) {
//	double v = numerator / denominator;
//	if(v > 1e-8) return RegProb(v);		// this is faster
//	else return LogProb(log(numerator) - log(denominator));
//}




