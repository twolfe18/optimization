
import std.algorithm;
import std.math, std.stdio, std.stream, std.string, std.random, std.conv;
import sample, probability, bimap;

struct Counts {
	uint[] counts;
	ulong sum;
	this(uint dimension) {
		this.counts.length = dimension;
		this.sum = 0;
	}
	void clear() {
		foreach(uint k, uint v; counts)
			counts[k] = 0;
		sum = 0;
	}
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
	Doc[] train;
	Doc[] test;
	double alpha, beta;	// dirichlet priors on topic and word distributions respectively
	int[string] stopwords;
	Bimap!string words;
	
	this(uint numTopics, double alpha, double beta) {
		this.numTopics = numTopics;
		this.alpha = alpha;
		this.beta = beta;
		for(auto z=0; z<numTopics; z++)
			phi_ss ~= Counts(numTopics);
	}
	
	void resetAggregates() {
		foreach(Counts c; phi_ss)
			c.clear();
		foreach(Doc d; train, test) {
			d.N_z.clear();
			foreach(uint i, uint w; d.w) {
				uint z = d.z[i];
				d.N_z.inc(z);
				phi_ss[i].inc(w);
			}
		}
	}
	
	void sample(uint iterations) {
		resetAggregates();
		for(auto iter=0; iter<iterations; iter++) {
			foreach(Doc d; train)
				for(auto i=0; i<d.length; i++)
					sample(d, i);
			LogProb held_out_likelihood = LogProb(0.0);
			foreach(Doc d; test)
				for(auto i=0; i<d.length; i++)
					held_out_likelihood = held_out_likelihood * sample(d, i);
		}
	}
	
	LogProb dirichletMultinomialProb(uint index, Counts ss, double dirichletPrior) {
		double num = ss.counts[index] + dirichletPrior;
		double denom = ss.sum + ss.dimension * dirichletPrior;
		return LogProb(log(num)-log(denom));
	}
	
	LogProb sample(Doc doc, int i) {
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
		return weights[z_new];
	}
	
	void printTopics(uint k) {
		foreach(uint c_i, Counts c; phi_ss) {
			uint[] topwords;
			for(uint i=0; i<this.words.length; i++)
				topwords ~= i;
			bool mycomp(uint a, uint b) { return c.counts[a] > c.counts[b]; }
			sort!(mycomp)(topwords);
			writef("topic %d:", c_i+1);
			foreach(uint w; topwords[0..k])
				write("\t", this.words.get(w));
			writeln();
		}
	}

	void setStopwords(string filename) {
		BufferedFile bf = new BufferedFile(filename);
		scope(exit) bf.close;
		while(!bf.eof) {
			auto line = strip(bf.readLine());
			string word = toLower!string(to!string(line));
			if(word.length == 0) continue;
			stopwords[word] = 1;
		}
		writefln("[setStopwords] read %d stopwords", stopwords.length);
	}
	
	// assumes one document per line
	void addDocumentsFromFile(string filename, string delim, double proptest) {
		BufferedFile bf = new BufferedFile(filename);
		scope(exit) bf.close;
		uint docsread = 0;
		while(!bf.eof) {
			char[] line = strip(bf.readLine());
			if(line.length == 0) continue;
			string[] words;
			foreach(char[] tok; split(line, delim)) {
				string stok = text(tok);
				if(stok in stopwords) continue;
				words ~= toLower!string(stok);
			}
			addDocument(words, uniform(0.0, 1.0) > proptest);
			docsread++;
		}
		writefln("[addDocsFromFile] added %d documents", docsread);
	}

	void addDocument(string[] words, bool train) {
		writeln("going into addDocument");
		Doc doc;
		foreach(string w; words) {
			w = toLower!string(w.idup);
			writeln("word = ", w);
			writeln("stopwords size = ", stopwords.length);
			if(w in this.stopwords) continue;
			writeln("about to go into bimap");
			ulong wid = this.words.lookupOrAdd(w);
			writeln("wid = ", wid);
			doc.w ~= cast(uint) wid;
			doc.z ~= uniform(0, numTopics);
		}
		writeln("got here");
		if(train) this.train ~= doc;
		else this.test ~= doc;
		writeln("leaving addDocument");
	}
	
}






