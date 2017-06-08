#include "DoublyLinkedList.h"
#include <stdexcept>
struct EmptyDLinkedListException : std::range_error {
  explicit EmptyDLinkedListException(char const* msg=NULL): range_error(msg) {}
};

DoublyLinkedList::DoublyLinkedList(const DoublyLinkedList& dll)
{
  // Initialize
  header.next = &trailer; trailer.prev = &header;
  
  // Copy
  DListNode *current = dll.getFirst();
  while (current != dll.getAfterLast()) {
    insertLast(current->getElem());
    current = current->getNext(); //iterate
  }
}
DoublyLinkedList& DoublyLinkedList::operator=(const DoublyLinkedList& dll)
{
  // Delete
  DListNode *prev_node, *node = header.next;
  while (node != &trailer) {
    prev_node = node;
    node = node->next;
    delete prev_node;
  }
  header.next = &trailer;
  trailer.prev = &header;
  
  // Copy
  DListNode *current = dll.getFirst();
  while (current != dll.getAfterLast()) {
    insertLast(current->getElem());
    current = current->getNext(); //iterate
  }
}
void DoublyLinkedList::insertFirst(int newobj)
{ 
  DListNode *newNode = new DListNode(newobj, &header, header.next);
  header.next->prev = newNode;
  header.next = newNode;
}
void DoublyLinkedList::insertLast(int newobj)
{
  DListNode *newNode = new DListNode(newobj, trailer.prev,&trailer);
  trailer.prev->next = newNode;
  trailer.prev = newNode;
}
int DoublyLinkedList::removeFirst()
{ 
  if (isEmpty())
    throw EmptyDLinkedListException("Empty Doubly Linked List");
  DListNode *node = header.next;
  node->next->prev = &header;
  header.next = node->next;
  int obj = node->obj;
  delete node;
  return obj;
}
int DoublyLinkedList::removeLast()
{
  if (isEmpty())
    throw EmptyDLinkedListException("Empty Doubly Linked List");
  DListNode *node = trailer.prev;
  node->prev->next = &trailer;
  trailer.prev = node->prev;
  int obj = node->obj;
  delete node;
  return obj;
}
DoublyLinkedList::~DoublyLinkedList()
{
  DListNode *prev_node, *node = header.next;
  while (node != &trailer) {
    prev_node = node;
    node = node->next;
    delete prev_node;
  }
  header.next = &trailer;
  trailer.prev = &header;
}
int DoublyLinkedList::first() const
{ 
  if (isEmpty())
    throw EmptyDLinkedListException("Empty Doubly Linked List");
  return header.next->obj;
}
int DoublyLinkedList::last() const
{
  if (isEmpty())
    throw EmptyDLinkedListException("Empty Doubly Linked List");
  return trailer.prev->obj;
}
int DoublyLinkedListLength(const DoublyLinkedList& dll) {
  DListNode *current = dll.getFirst();
  int count = 0;
  while(current != dll.getAfterLast()) {
    count++;
    current = current->getNext(); //iterate
  }
  return count;
}
ostream& operator<<(ostream& out, const DoublyLinkedList& dll) {
  DListNode *current = dll.getFirst();
  while (current != dll.getAfterLast()) {
    out << current->getElem() << " ";
    current = current->getNext(); //iterate
  }
  return out;
}
