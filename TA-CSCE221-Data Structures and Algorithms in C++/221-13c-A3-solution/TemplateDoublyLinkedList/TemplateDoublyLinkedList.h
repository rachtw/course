#include <cstdlib>
#include <iostream>
#include <stdexcept>
using namespace std;
struct EmptyDLinkedListException : std::range_error {
  explicit EmptyDLinkedListException(char const* msg=NULL): range_error(msg) {}
};
template <typename T> class DoublyLinkedList;
template <typename T> 
class DListNode {
private: T obj;
  DListNode<T> *prev;
  DListNode<T> *next;
  friend class DoublyLinkedList<T>;
public:
  DListNode(T e = T(), DListNode<T> *p = NULL, DListNode<T> *n = NULL)
    : obj(e), prev(p), next(n) {}
  T getElem() const { return obj; }
  DListNode<T> * getNext() const { return next; }
  DListNode<T> * getPrev() const { return prev; }
};

template <typename T> 
class DoublyLinkedList {
protected: DListNode<T> header, trailer;
public:
  DoublyLinkedList() : header(), trailer()
  { header.next = &trailer; trailer.prev = &header; }
  DoublyLinkedList(const DoublyLinkedList<T>& dll);
  ~DoublyLinkedList();
  DoublyLinkedList<T>& operator=(const DoublyLinkedList<T>& dll);
  DListNode<T> *getFirst() const { return header.next; }
  const DListNode<T> *getAfterLast() const { return &trailer; }
  bool isEmpty() const { return header.next == &trailer; }
  T first() const;
  T last() const;
  void insertFirst(T newobj);
  T removeFirst();
  void insertLast(T newobj);
  T removeLast();
};
template <typename T>
DoublyLinkedList<T>::DoublyLinkedList(const DoublyLinkedList<T>& dll)
{
  // Initialize
  header.next = &trailer; trailer.prev = &header;
  
  // Copy
  DListNode<T> *current = dll.getFirst();
  while (current != dll.getAfterLast()) {
    insertLast(current->getElem());
    current = current->getNext(); //iterate
  }
}
template <typename T>
DoublyLinkedList<T>& DoublyLinkedList<T>::operator=(const DoublyLinkedList<T>& dll)
{
  // Delete
  DListNode<T> *prev_node, *node = header.next;
  while (node != &trailer) {
    prev_node = node;
    node = node->next;
    delete prev_node;
  }
  header.next = &trailer;
  trailer.prev = &header;
  
  // Copy
  DListNode<T> *current = dll.getFirst();
  while (current != dll.getAfterLast()) {
    insertLast(current->getElem());
    current = current->getNext(); //iterate
  }
}
template <typename T>
void DoublyLinkedList<T>::insertFirst(T newobj)
{ 
  DListNode<T> *newNode = new DListNode<T>(newobj, &header, header.next);
  header.next->prev = newNode;
  header.next = newNode;
}
template <typename T>
void DoublyLinkedList<T>::insertLast(T newobj)
{
  DListNode<T> *newNode = new DListNode<T>(newobj, trailer.prev,&trailer);
  trailer.prev->next = newNode;
  trailer.prev = newNode;
}
template <typename T>
T DoublyLinkedList<T>::removeFirst()
{ 
  if (isEmpty())
    throw EmptyDLinkedListException("Empty Doubly Linked List");
  DListNode<T> *node = header.next;
  node->next->prev = &header;
  header.next = node->next;
  T obj = node->obj;
  delete node;
  return obj;
}
template <typename T>
T DoublyLinkedList<T>::removeLast()
{
  if (isEmpty())
    throw EmptyDLinkedListException("Empty Doubly Linked List");
  DListNode<T> *node = trailer.prev;
  node->prev->next = &trailer;
  trailer.prev = node->prev;
  T obj = node->obj;
  delete node;
  return obj;
}
template <typename T>
DoublyLinkedList<T>::~DoublyLinkedList()
{
  DListNode<T> *prev_node, *node = header.next;
  while (node != &trailer) {
    prev_node = node;
    node = node->next;
    delete prev_node;
  }
  header.next = &trailer;
  trailer.prev = &header;
}
template <typename T>
T DoublyLinkedList<T>::first() const
{ 
  if (isEmpty())
    throw EmptyDLinkedListException("Empty Doubly Linked List");
  return header.next->obj;
}
template <typename T>
T DoublyLinkedList<T>::last() const
{
  if (isEmpty())
    throw EmptyDLinkedListException("Empty Doubly Linked List");
  return trailer.prev->obj;
}
template <typename T>
T DoublyLinkedListLength(DoublyLinkedList<T>& dll) {
  DListNode<T> *current = dll.getFirst();
  int count = 0;
  while(current != dll.getAfterLast()) {
    count++;
    current = current->getNext(); //iterate
  }
  return count;
}
template <typename T>
ostream& operator<<(ostream& out, const DoublyLinkedList<T>& dll) {
  DListNode<T> *current = dll.getFirst();
  while (current != dll.getAfterLast()) {
    out << current->getElem() << " ";
    current = current->getNext(); //iterate
  }
  return out;
}