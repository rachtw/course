#include <vector>
#include <string>
#include <iostream>
#include <fstream>
#include <algorithm>
using namespace std;

//E: (key,element) pair; K: key; X: element
template <typename E, typename K, typename X> 
class AdaptPriorityQueue { 
public:
  typedef std::vector<E> ElementVector; // based on heap
private:
  ElementVector V;
public:
  // locator class
  class Position {
  private:
    int index; // index of the heap array
  public:
    Position(int i=0): index(i) {}
    const E& operator*(/*empty arguments*/) { return V[index]; }
    int getIndex() const { return index; }
    void setIndex(int i) { index=i; }
    friend class AdaptPriorityQueue;
  };
private:

  // swap the key element pairs at index 1 and index 2
  void swap(int index1, int index2) {
    K k=V[index1].getKey();
    X x=V[index1].getElement();
    Position* p=V[index1].getPosition();
    
    V[index1].setKey(V[index2].getKey());
    V[index1].setElement(V[index2].getElement());
    V[index1].setPosition(V[index2].getPosition());
    V[index1].getPosition()->setIndex(index1);
        
    V[index2].setKey(k);
    V[index2].setElement(x);
    V[index2].setPosition(p);
    V[index2].getPosition()->setIndex(index2);
  }
  
  // perform a walk down on V[index]
  void walkDown(int index) {
    int child=index*2+1;
    while (child < V.size()) { // if left child exists
      // if right child exists and right child < left child
      if ( child+1 < V.size() && V[child+1](V[child]) ) {
        child++;
      }
      // if child < current
      if ( V[child]( V[index] ) ) {
        swap(index,child);
      } else
        break;
      index=child;
      child=child*2+1;
    }
  }
  
  // perform a walk up on V[index]
  void walkUp(int index) {
    int parent=(index-1)/2;
    while (index > 0) {
      if ( V[index](V[parent]) )
        swap(index,parent);
      else
        break;
      index=parent;
      parent=(parent-1)/2;
    }
  }  
public:
  ElementVector& getVector() { return V; }
  E getElement(const Position& p) const { return V[p.getIndex()]; }
  
  // insert a (key,element) pair (k,x) with its index recorded in p
  void insert(const K& k, const X& x, Position* p) {
    // place the key-element pair at the back of the vector
    E e(k,x,p);
    V.push_back(e);
    p->setIndex(V.size()-1);
    
    // restructure
    walkUp(V.size()-1);
  }
  
  // returns the locator with min key
  Position min() {
    return *(V[0].getPosition());
  }
  
  // removes (key,element) pair at p
  void remove(const Position& p) {  
    // replace its value by the last key-element pair
	// erase the last key-element pair
    typename ElementVector::iterator q=V.end();
    --q;
    V[p.getIndex()].setKey(q->getKey());
    V[p.getIndex()].setElement(q->getElement());
    V[p.getIndex()].setPosition(q->getPosition());
    V.erase(q);
  
    // restructure
    walkUp(p.getIndex());
    walkDown(p.getIndex());
  }
  
  // check if it's empty
  bool isEmpty() const { return V.empty(); }
  
  // replaces key by k
  void decreaseKey(const Position& p,const K& k) {
    V[p.getIndex()].setKey(k);
  
    // restructure
    walkUp(p.getIndex());
    walkDown(p.getIndex());
  }
  
  // reads pairs of key & element from a file, and fill an array of locators
  // restructure the heap using bottom-up heap construction
  void createPriorityQueue(string file, Position* loc) {
    V.clear();
    ifstream fin(file.c_str());
    string str;
    int k,x;
    while (fin >> k) {
      fin >> x;
      // toss
      V.push_back(E());
      V[V.size()-1].setKey(k);
      V[V.size()-1].setElement(x);
      V[V.size()-1].setPosition(&loc[V.size()-1]);
      
	  // set up locator array from main()
      loc[V.size()-1].setIndex(V.size()-1);
    }
    fin.close();
    fin.clear();
     
	// linear time bottom-up heap contruction
    for (int i = (V.size()-2)/2; i >= 0; i--) {
      walkDown(i);
    }
  }
 
};

// output the heap vector
template <typename E, typename K, typename X> 
ostream& operator<<(ostream& out, AdaptPriorityQueue<E,K,X>& apq) {
  typename AdaptPriorityQueue<E,K,X>::ElementVector::iterator q;
  typename AdaptPriorityQueue<E,K,X>::ElementVector V=apq.getVector();
  for (q=V.begin();q!=V.end();++q)
      out << *q << endl;
  return out;
} 
