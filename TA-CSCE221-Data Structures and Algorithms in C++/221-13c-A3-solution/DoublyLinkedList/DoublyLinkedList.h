#include <cstdlib>
#include <iostream>
using namespace std;
class DoublyLinkedList; // class declaration
class DListNode {
private: int obj;
  DListNode *prev, *next;
  friend class DoublyLinkedList;
public:
  DListNode(int e=0, DListNode *p = NULL, DListNode *n = NULL)
    : obj(e), prev(p), next(n) {}
  int getElem() const { return obj; }
  DListNode * getNext() const { return next; }
  DListNode * getPrev() const { return prev; }
};
class DoublyLinkedList {
protected: DListNode header, trailer;
public:
  DoublyLinkedList() : header(0), trailer(0)
  { header.next = &trailer; trailer.prev = &header; }
  DoublyLinkedList(const DoublyLinkedList& dll);
  ~DoublyLinkedList();
  DoublyLinkedList& operator=(const DoublyLinkedList& dll);
  DListNode *getFirst() const { return header.next; }
  const DListNode *getAfterLast() const { return &trailer; }
  bool isEmpty() const { return header.next == &trailer; }
  int first() const;
  int last() const;
  void insertFirst(int newobj);
  int removeFirst();
  void insertLast(int newobj);
  int removeLast();
};
ostream& operator<<(ostream& out, const DoublyLinkedList& dll);