#include <iostream>
#include <string>
#include <set>
#include <climits>
#include <stack>
#include "Graph.h"
#include "Main.h"

using namespace std;

int main()
{       // you can use the following code to test your graph. 
        // you can also change your input file to do more testing
        // verify the results

	string str("random_sparse.txt");
	//string str("small.txt");
	Graph graph(str);
	graph.PrintGraph();
	
	// for extracting minimum key
	AdaptPriorityQueue<KeyElementPair,int,int> apq;
	// for updating keys in pq
	AdaptPriorityQueue<KeyElementPair,int,int>::Position* locatorArray=new AdaptPriorityQueue<KeyElementPair,int,int>::Position[graph.getNumVertices()+1];
	
	// for recording shortest path
	int* shortestPathParent=new int[graph.getNumVertices()+1];
	for (int i=0;i<graph.getNumVertices()+1;i++) {
		shortestPathParent[i]=i;
	}
	
	// initialize the data structure
	set<int> S;
	vector<Vertex*> vertList=graph.getVertices();
	for (vector<Vertex*>::const_iterator itVert=vertList.begin();
			itVert!=vertList.end();itVert++) {
		//cout << "Inserting " << (*itVert)->getID() << endl;
		apq.insert(INT_MAX,(*itVert)->getID(),&locatorArray[(*itVert)->getID()]);
		//cout << "Queue:" << endl << apq;
	}
	
	int s;
	cout << "Please enter the source vertex: ";
	cin >> s;
	apq.decreaseKey(locatorArray[s],0);
	//cout << "Queue:" << endl << apq;
	
	int updated_weight,neighbor;
	AdaptPriorityQueue<KeyElementPair,int,int>::Position p;
	while (!apq.isEmpty()) {
		p=apq.min();
		int v_ID=apq.getKeyElement(p).getElement();
		int v_weight=apq.getKeyElement(p).getKey();
		apq.remove(p);
		//cout << "Remove " << v_ID << " " << v_weight << endl;
		//cout << "Queue:" << endl << apq;
		
		vector<Edge*> outList=graph.getVertexP(v_ID)->getOutEdges();
		//cout << "Its outedges:" << endl;
		//graph.getVertexP(v_ID)->printOutEdges();
		for (vector<Edge*>::const_iterator itEdge=outList.begin();
				itEdge!=outList.end();itEdge++) {
			neighbor=(*itEdge)->geteVertP()->getID();
			//cout << "Neighbor " << neighbor << endl;
			if (S.find(neighbor)==S.end()) {
				int neighbor_weight=apq.getKeyElement(locatorArray[neighbor]).getKey();
				if ((*itEdge)->getWeight()!=INT_MAX && 
					(updated_weight=v_weight + (*itEdge)->getWeight()) < neighbor_weight) {
					apq.decreaseKey(locatorArray[neighbor],updated_weight);
					shortestPathParent[neighbor]=v_ID;
				}
				//cout << "After relaxation" << endl;
				//cout << "Queue:" << endl << apq;
			}
		}
	}
	
	for (int i=1;i<graph.getNumVertices()+1;i++) {
		int d=i;
		stack<Edge*> path;
		bool found_path=true;
		if (d==s) continue;
		while (d!=s) {
			if (d==shortestPathParent[d]) {
				cout << "No path to " << d << " from " << s;
				found_path=false;
				break;
			}
			Edge* e=graph.getEdgeP(shortestPathParent[d],d);
			if (e->getWeight()==INT_MAX) {
				cout << "No path to " << d << " from " << s;
				found_path=false;
				break;
			}			
			path.push(e);
			d=shortestPathParent[d];
		} //while
		if (found_path) {
			cout << s;
			while (!path.empty()) {
				Edge* e=path.top();
				path.pop();
				cout << " --" << e->getWeight() << "--> " << (*e->geteVertP());
			}
			cout << endl;
		}
	}
	return 0;
}