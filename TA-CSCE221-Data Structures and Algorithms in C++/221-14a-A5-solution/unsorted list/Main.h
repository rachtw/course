#include <iostream>
#include "AdaptPriorityQueue.h"
using namespace std;
class KeyElementPair {
private:
  int key;
  int element;
  AdaptPriorityQueue<KeyElementPair,int,int>::Position* pos;
public:
  KeyElementPair(int k=-1,int x=0,AdaptPriorityQueue<KeyElementPair,int,int>::Position* p=NULL) : key(k),element(x),pos(p) {}
  //less-than function
  bool operator()(const KeyElementPair& kep) const { return key < kep.key;}
  void setKey(int k) { key=k; }
  void setPosition(AdaptPriorityQueue<KeyElementPair,int,int>::Position* p) { pos=p; }
  int getKey() const { return key; }
  int getElement() const { return element; }
  const AdaptPriorityQueue<KeyElementPair,int,int>::Position* getPosition() const { return pos; }
};
ostream& operator<<(ostream& out, const KeyElementPair& kep) {
	out << kep.getKey() << " " << kep.getElement() << " " << kep.getPosition();
	return out;
}
