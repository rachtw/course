#include <list>
#include <string>
#include <iostream>
#include <fstream>
using namespace std;
//(key,element) pair, key, element
template <typename E, typename K, typename X> 
class AdaptPriorityQueue { 
public:
  typedef std::list<E> ElementList; // based on unsorted list
private:
  ElementList L;  
public:
  /* Position p=PQ.min();
   * KeyElementPair kep=*p; 
   * int k =kep.key;
   * int e =key.element;
   *
   * To use this definition of Position class, your data structure must be a STL container
   *
   * To get an iterator of a certain element in the std::list or std::vector,
   * 1. list::iterator it=L.begin(); // iterator of the first element
   *    or 
   *    list::iterator it=L.end(); it--; // iterator of the last element
   * 2. Begin your search of the min. element using list::iterator or vector::iterator
   *
   * Specifically, to create an iterator to V[i] of a vector, you can write
   *    vector::iterator it=V.begin()+i;
   */
  class Position {
  public:
    typename ElementList::iterator q;
    const E& operator*(/*empty arguments*/) { return *q; }
    friend class AdaptPriorityQueue;
  };
public:
  ElementList& getList() { return L; }
  // insert a (key,element) pair (k,x)
  Position insert(const K& k, const X& x, Position* p) {
    E e(k,x,p);
    L.push_back(e);
    p->q=--L.end();    
    return *p;    
  }
  // returns the location with min key
  Position min() {
    typename ElementList::iterator q=L.begin();
    E min(*q);
    for (++q;q!=L.end();++q) {
      //cout << "min=" << min << endl;
      //cout << "q=" << (*q) << endl;
      if ((*q)(min)) {
        min=*q;
        //cout << "=> min=" << min << endl;
      }
    }
    return *min.getPosition();
  }
  // removes (key,element) pair at p
  void remove(const Position& p) {
    L.erase(p.q);
  }
  // check if it's empty
  bool isEmpty() const { return L.empty(); }
  // replaces key by k
  void decreaseKey(const Position& p,const K& k) {
    (*p.q).setKey(k);
  }
  // reads pairs of key & element from a file
  void createPriorityQueue(string file, Position* loc) {
    L.clear();
    ifstream fin(file.c_str());
    int k,x,i=0;
    while (fin >> k) {
      fin >> x;
      insert(k,x,&loc[i]);
      i++;
      //cout << *this << endl;
    }
    fin.close();
    fin.clear();
  }
 
};
template <typename E, typename K, typename X> 
ostream& operator<<(ostream& out, AdaptPriorityQueue<E,K,X>& apq) {
  typename AdaptPriorityQueue<E,K,X>::ElementList::iterator q;
  typename AdaptPriorityQueue<E,K,X>::ElementList L=apq.getList();
  for (q=L.begin();q!=L.end();++q) {
      out << *q << " ";
      out << (*(q->getPosition()->q)) << endl;
  }
  return out;
} 
