#include <iostream>
#include "AdaptPriorityQueue.h"
using namespace std;
// (key,element) pair with its locator at address pos. 
// The locator should store the heap vector index of the pair.
class KeyElementPair {
private:
  int key;
  int element;
  AdaptPriorityQueue<KeyElementPair,int,int>::Position* pos; // points to the location array outside
public:
  KeyElementPair(int k=-1,int x=0,AdaptPriorityQueue<KeyElementPair,int,int>::Position* p=NULL) : key(k),element(x),pos(p) {}
  //less-than function
  bool operator()(const KeyElementPair& kep) const { return key < kep.key;}
  void setKey(int k) { key=k; }
  void setElement(int x) { element=x; }
  int getKey() const { return key; }
  int getElement() const { return element; }
  AdaptPriorityQueue<KeyElementPair,int,int>::Position* getPosition() { return pos; }
  void setPosition(AdaptPriorityQueue<KeyElementPair,int,int>::Position* p) { pos=p; }
};
ostream& operator<<(ostream& out, KeyElementPair& kep) {
  out << kep.getKey() << " " << kep.getElement() << " " << kep.getPosition();
  return out;
}

