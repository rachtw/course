#ifndef GRAPH_H
#define GRAPH_H

#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <iostream>
#include "Vertex.h"
#include "Edge.h"

using namespace std;

class Edge;
class Vertex;

class Graph{

private:
	vector<Vertex*> vertList;
	vector<Edge*> edgeList;
public:
	Graph(string filename) {
		ifstream ifs(filename.c_str());
		int vertnum;
		ifs>>vertnum;
		for(int i=0;i<vertnum;i++) // push all vertices into the vertex vector before assigning the in and out list
		{
			Vertex *vert = new Vertex(i+1);
			vertList.push_back(vert);
		}
		int svert,evert,weit; 
		ifs>>svert; 
		//cout << svert << " ";
		while(svert!=-1)
		{
			ifs>>evert; 
			//cout << evert << " ";
			while(evert!=-1)
			{
				ifs>>weit; // one weight means one edge
				//cout << weit << " ";
				Edge *tempedge = new Edge(vertList[svert-1],vertList[evert-1],weit); // new edge
				edgeList.push_back(tempedge);				
				vertList[svert-1]->outList.push_back(tempedge);
				vertList[evert-1]->inList.push_back(tempedge);
				ifs>>evert; 
				//cout << evert << " ";
			}
			//cout << endl;
			ifs>>svert; 
			//cout << svert << " ";
		}
		ifs.close();
		//cout << endl;
	}
	~Graph() {
		for(int i = 0; i < vertList.size(); i++)
			delete vertList[i];
		for(int i = 0; i < edgeList.size(); i++)
			delete edgeList[i];
	}
	Vertex* getVertexP(int id) {
		return vertList[id-1];
	}
	Edge* getEdgeP(int s,int d) {
		vector<Edge*> outList=vertList[s-1]->getOutEdges();
		for (vector<Edge*>::const_iterator itEdge=outList.begin();
				itEdge!=outList.end();++itEdge) {	
			if (((*itEdge)->geteVertP()->getID())==d) {
				return *itEdge;
			}
		}
		Edge* e=new Edge();
		return e;
	}
	vector<Vertex*> getVertices() const {
		return vertList;
	}
	int getNumVertices() const {
		return vertList.size();
	}
	void PrintGraph() // print out all the edges and associated vertices in the entire graph
	{
		cout << "Graph:" << endl;
		for (vector<Vertex*>::const_iterator itVert=vertList.begin();
				itVert!=vertList.end();itVert++) {
			cout << *(*itVert) << "'s out edges:" << endl;
			(*itVert)->printOutEdges();
		}
	}
};
#endif