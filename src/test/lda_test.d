
import lda;

void main() {
	
	uint topics = 12;
	LDA lda = new LDA(topics, 0.01, 0.01);
	lda.setStopwords("/Users/travis/Dropbox/research/federalist_papers/stopwords.txt");
	lda.addDocumentsFromFile(
		"/Users/travis/Dropbox/research/federalist_papers/fulltext.txt",
		" ", 0.2);
	lda.sample(500);
	
}


