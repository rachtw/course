#include <fstream>
#include <iostream>
#include <algorithm>
#include <vector>
#include <list>
#include <cstdlib>
#include <stdexcept>
#include "Question.h"

using namespace std;

vector<Question> vectQuestions;
list<Question> listQuestions;

// read the text file of questions
void readQuestions(istream& in) {
	Question q;
	while (in >> q) {
		vectQuestions.push_back(q);
		listQuestions.push_back(q);
	}
	if (in.eof()) return;
	in.clear(ios_base::failbit);
}

// overload the function to get n-th question
// from the vector
Question getNthQuestion(const vector<Question>& vectQuestions, int n) {
	return vectQuestions.at(n);
}

// from the list
Question getNthQuestion(const list<Question>& listQuestions, int n) {
	int i=0;
	for (list<Question>::const_iterator it=listQuestions.begin();
			it!=listQuestions.end();++it) {
			if (i==n) return *it;
			++i;
	}
}

int main(int argc,char* argv[]) {
	ifstream ist(argv[1]);
	if (!ist) throw runtime_error("can't open input file");
	readQuestions(ist);
	
	// Game starts: 
	// 0. ask user choose from vector or list	
	int c;
	cout << "Choose from 1. std::vector; 2. std::list: ";
	while (!(cin >> c)) throw runtime_error("not integer");
	if (c!=1 && c!=2) throw out_of_range("choose from 1 and 2");
	
	// 1. randomly select 10 Questions by shuffling question no's
	srand(time(NULL));
	
	int questionNo[]={0,1,2,3,4,5,6,7,8,9,10,11,12,13,14};
	random_shuffle(questionNo,questionNo+15);

	int correctCount=0;
	for (int i=0; i<10; i++) {
		// 2. use << operator to output a Question
		Question q;
		if (c==1) cout << (q=getNthQuestion(vectQuestions, questionNo[i]));
		else if (c==2) cout << (q=getNthQuestion(listQuestions, questionNo[i]));
		
		// 3. get answer from user and verify the answer
		cout << "You answer:";
		while (!(cin >> c)) throw runtime_error("not integer");
		if (c==q.getCorrectChoice()) {
			cout << "Correct!" << endl << endl;
			++correctCount;
		}
		else if (c>q.getNumberChoices() || c<1) throw out_of_range("");
		else cout << "Wrong!" << endl << endl;
	}
	// 4. output score and pass/fail
	cout << "You scored " << correctCount << "/10" << endl;
	if (correctCount>=7) cout << "You have passed!" << endl;
	else cout << "You have failed!" << endl;
	
	return EXIT_SUCCESS;
}
