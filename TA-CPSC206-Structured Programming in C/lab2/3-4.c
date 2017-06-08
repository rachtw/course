/* Author: Mu-Fen Hsieh
 * Date: July 12, 2006
 * File Name: 3-4.c
 * Description: A sample program for Exercise 3-4
 */
#include <stdio.h>
int main(void) {
  int a=1, b=2, c=3;
  float x=3.3, y=5.5;
  printf("%d %d\n", !a+b/c,!a+b/c);
  printf("%d %d\n", a==-b+c,a*b>c==a);
  printf("%d %d\n", !!x<a+b+c, !!x+!!!y);
  printf("%d %d\n", a||b==x&&y,!(x||!y));
  return 0;
}
