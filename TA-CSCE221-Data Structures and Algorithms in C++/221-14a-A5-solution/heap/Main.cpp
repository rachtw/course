#include "Main.h"
using namespace std;

/*
  Key-element integer pairs. They represent distances and number of stops 
  from the BWI airport to the nine airports, 
  from the textbook figure 13.15(g) at p.642.

  //key (distance), element (stops) to the city 
  2467 -1 // SFO 
  3288 -1 // LAX 
  621 0 // ORD 
  1423 -1 // DFW 
  84 0 // JFK 
  371 1 // BOS 
  328 1 // PVD 
  0 0 // BWI 
  946 0 // MIA   
*/
  
int main() {
  AdaptPriorityQueue<KeyElementPair,int,int> apq;
  AdaptPriorityQueue<KeyElementPair,int,int>::Position* locators=new AdaptPriorityQueue<KeyElementPair,int,int>::Position[26];
  
  // create PQ; assign locators randomly
  apq.createPriorityQueue("test.txt",locators);
  cout << apq << endl;
  
  // heap sort
  AdaptPriorityQueue<KeyElementPair,int,int>::Position loc;
  while (!apq.isEmpty()) {
    loc=apq.min();
    KeyElementPair kep=apq.getElement(loc);
    cout << kep << endl;
    apq.remove(loc);
  }
  cout << endl;
  
  // create PQ again; and assign locators according to the city name
  apq.insert(2467,-1,&locators['S'-'A']);
  apq.insert(3288,-1,&locators['L'-'A']);
  apq.insert(621,0,&locators['O'-'A']);
  apq.insert(1423,-1,&locators['D'-'A']);
  apq.insert(84,0,&locators['J'-'A']);
  apq.insert(371,1,&locators['B'-'A']);
  apq.insert(328,1,&locators['P'-'A']);
  apq.insert(0,0,&locators['W'-'A']);
  apq.insert(946,0,&locators['M'-'A']);
  cout << apq << endl;
  
  // replace the key of LAX to 2658, as in Figure 13.14(h)
  apq.decreaseKey(locators['L'-'A'],2658);
  cout << "replace key of LAX by 2658:" << endl;  
  cout << apq << endl; 
  
  cout << "SFO " << apq.getElement(locators['S'-'A']).getKey() << endl;
  cout << "LAX " << apq.getElement(locators['L'-'A']).getKey() << endl;
  cout << "ORD " << apq.getElement(locators['O'-'A']).getKey() << endl;
  cout << "DFW " << apq.getElement(locators['D'-'A']).getKey() << endl;
  cout << "JFK " << apq.getElement(locators['J'-'A']).getKey() << endl;
  cout << "BOS " << apq.getElement(locators['B'-'A']).getKey() << endl;
  cout << "PVD " << apq.getElement(locators['P'-'A']).getKey() << endl;
  cout << "BWI " << apq.getElement(locators['W'-'A']).getKey() << endl;
  cout << "MIA " << apq.getElement(locators['M'-'A']).getKey() << endl;
  
}