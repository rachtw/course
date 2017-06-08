/* Author: Mu-Fen Hsieh
 * Date: July 12, 2006
 * File Name: 3-2.c
 * Description: A sample program for Exercise 3-2
 */
#include <stdio.h>
int main(void) {
  int a=1, b=2, c=3,d=4;
  double x=1.0;
  
  /* Evaluate the first expression */
  
  printf("%d\n", a>b&&c<d);
  
  a=1, b=2, c=3,d=4;
  x=1.0;
  printf("%d\n", (a>b)&&(c<d));
  
  /* Evaluate the second expression */
  
  a=1, b=2, c=3,d=4;
  x=1.0;
  printf("%d\n", a<!b||!!a);
  
  a=1, b=2, c=3,d=4;
  x=1.0;
  printf("%d\n", (a<(!b))||(!(!a)));
  
  /* Evaluate the third expression */
  
  a=1, b=2, c=3,d=4;
  x=1.0;
  printf("%d\n", a+b<!c+c);
  
  a=1, b=2, c=3,d=4;
  x=1.0;
  printf("%d\n", (a+b)<((!c)+c));
  
  /* Evaluate the fourth expression */
  
  a=1, b=2, c=3,d=4;
  x=1.0;
  printf("%d\n", a-x||b*c&&b/a);
  
  a=1, b=2, c=3,d=4;
  x=1.0;
  printf("%d\n", (a-x)||((b*c)&&(b/a)));
  
  /* Return successfully */
  
  return 0;
}
