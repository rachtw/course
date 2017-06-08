all: Main

Main: Main.o Question.o
	g++-4.7 -std=c++11 Main.o Question.o -o Main

Main.o: Main.cpp Question.h
	g++-4.7 -std=c++11 -c Main.cpp

Question.o: Question.cpp Question.h
	g++-4.7 -std=c++11 -c Question.cpp

clean:
	rm *.o Main

