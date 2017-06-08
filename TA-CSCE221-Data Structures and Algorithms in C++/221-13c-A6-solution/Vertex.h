#ifndef VERTEX_H
#define VERTEX_H

#include <vector>
#include <iostream>
#include "Edge.h"

using namespace std;

class Edge;

class Vertex {

private:
	vector<Edge*> inList; // source vertex
  vector<Edge*> outList; // end vertex 
	int id;
	friend class Graph;
public:
	Vertex(int sid): id(sid) {}
	int getID() const { return id; }
	vector<Edge*> getOutEdges() const { return outList; }
	vector<Edge*> getInEdges() const { return inList; }
	void printOutEdges() {
		for (vector<Edge*>::const_iterator cit=outList.begin();
				 cit!=outList.end();++cit) {
			cout << (*(*cit)) << endl;
		}
	}
};
ostream& operator<<(ostream& out,const Vertex& v) {
	out << v.getID();
	return out;
}
#endif