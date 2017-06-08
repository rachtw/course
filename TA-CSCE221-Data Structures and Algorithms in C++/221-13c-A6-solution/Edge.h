// #pragma once 
#ifndef EDGE_H
#define EDGE_H

#include <iostream>
#include <vector>
#include "Vertex.h"

using namespace std;


class Vertex;
ostream& operator<<(ostream& out,const Vertex& v);

class Edge {

private:

	Vertex *sVertP; // source vertex pointer
	Vertex *eVertP;  // end vertex pointer
	int weight; // edge weight 
public:
	Edge(Vertex* svert=NULL,Vertex* evert=NULL,int weight=INT_MAX):
		sVertP(svert), eVertP(evert), weight(weight) {}
	int getWeight() const { return weight; }
	Vertex* getsVertP() const { return sVertP; }
	Vertex* geteVertP() const { return eVertP; }
};
ostream& operator<<(ostream& out,const Edge& e) {
	Vertex* s=e.getsVertP();
	Vertex* d=e.geteVertP();
	out << (*s) << " " << (*d) << " " << e.getWeight();
	return out;
}
#endif