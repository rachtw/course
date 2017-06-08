#include "Question.h"
#include <cstdlib>
#include <stdexcept>
#include <iterator>

using namespace std;

//copy constructor
Question::Question(const Question& q) {
	question=q.question;
	choices=q.choices;
	answer=q.answer;
}

//copy assignment operator
Question& Question::operator=(const Question& q) {
	question=q.question;
	choices=q.choices;
	answer=q.answer;	
}

//equality operator
bool Question::operator==(const Question& q) const {
	return (question==q.question && choices==q.choices && answer==q.answer);
}

int Question::getCorrectChoice() const {
	return answer;
}

int Question::getNumberChoices() const {
	return choices.size();
}

const std::string Question::getChoice(int i) const {
	return choices[i];
}

const std::string Question::getQuestion() const {
	return question;
}

void Question::setCorrectChoice(int i) {
	answer=i;
}

void Question::setChoices(const std::vector<std::string>& v) {
	choices=v;
}

void Question::setQuestion(const std::string& s) {
	question=s;
}

//I/O output operator
ostream& operator<<(ostream& out, const Question& q) {
	out << q.getQuestion() << endl;
	int choiceSize=q.getNumberChoices();
	for (int i=0;i<choiceSize;i++) {
		out << (i+1) << ":" << q.getChoice(i) << endl;
	}
}

//I/O input operator
istream& operator>>(istream& in, Question& q) {
	string question;
	getline(in,question);
	if (question.empty()) return in;
	//cerr << question << endl;
	
	// store choices
	vector<string> choices;
	string s;
	while (getline(in,s) && !s.empty())
		choices.push_back(s);
	//copy(choices.begin(),choices.end(),ostream_iterator<string>(cerr,"\n"));
	
	// the last line is actually the answer, not a choice
	if (choices[choices.size()-1].length() > 1)
		throw out_of_range("");
	if (!isdigit(choices[choices.size()-1].at(0))) 
		throw runtime_error("not integer");
	int answer=atoi(choices[choices.size()-1].c_str());
	choices.pop_back();
	//cerr << "answer=" << answer << endl;

	q.setQuestion(question);
	q.setChoices(choices);
	q.setCorrectChoice(answer);
	
	return in;
}

