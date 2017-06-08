#include <string>
#include <vector>
#include <iostream>

class Question {
private:
	std::string question;
	std::vector<std::string> choices;
	int answer;
public:
	//constructor
	Question() {}
	//destructor
	//~Question();
	//copy constructor
	Question(const Question& q);
	//copy assignment operator
	Question& operator=(const Question& q);
	//equality operator
	bool operator==(const Question& q) const;
	int getCorrectChoice() const;
	void setCorrectChoice(int i);
	void setChoices(const std::vector<std::string>& v);
	void setQuestion(const std::string& s);
	int getNumberChoices() const;
	const std::string getChoice(int i) const;
	const std::string getQuestion() const;
};

//I/O output operator
std::ostream& operator<<(std::ostream& out, const Question& q);
//I/O input operator
std::istream& operator>>(std::istream& in, Question& q);
