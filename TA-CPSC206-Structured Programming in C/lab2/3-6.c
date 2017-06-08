/* Author: Mu-Fen Hsieh
 * Date: July 12, 2006
 * File Name: 3-6.c
 * Description: A sample program for Exercise 3-6.
 *              I do the three trials in this program.
 *              This shows that if the number has an
 *              extreme magnitude or there's a huge 
 *              difference in the magnitude of the 
 *              numbers, the type of floating points
 *              in a computer cannot approximate the
 *              number and calculation very well.
 */
#include <stdio.h>
int main(void) {
  double x=1e+33, y=0.001;
  printf("%d\n",x+y>x-y);
  
  x=1e+33, y=1000;
  printf("%d\n",x+y>x-y);
  
  x=1e+33, y=1000000;
  printf("%d\n",x+y>x-y);
  
  return 0;
}
