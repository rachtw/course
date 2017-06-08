/* Author: Mu-Fen Hsieh
 * Date: Jun 22, 2006
 * File Name: 2-13.c
 * Description: A sample program for Excercise 2-13
 */

#include <stdio.h>

int main(void) {
  int a=2, b=-3, c=5, d=-7, e=11, f=-3;

  /* These expressions have the value of 0 */
  printf("%d\n", a/b/c);

  a=2, b=-3, c=5, d=-7, e=11, f=-3;
  printf("%d\n", (a/b)/c);

  /* These expressions have the value of 4 */
  a=2, b=-3, c=5, d=-7, e=11, f=-3;
  printf("%d\n", 7+c*--d/e);

  a=2, b=-3, c=5, d=-7, e=11, f=-3;
  printf("%d\n", 7+((c*(--d))/e));

  /* These expreessions have the value of 7 */
  a=2, b=-3, c=5, d=-7, e=11, f=-3;
  printf("%d\n", 2*a%-b+c+1);

  a=2, b=-3, c=5, d=-7, e=11, f=-3;
  printf("%d\n", (((2*a)%(-b))+c)+1);

  /* These expressions have the value of -7 */
  a=2, b=-3, c=5, d=-7, e=11, f=-3;
  printf("%d\n", 39/-++e-+29%c);

  a=2, b=-3, c=5, d=-7, e=11, f=-3;
  printf("%d\n", (39/(-(++e)))-((+29)%c)));

  /* These expressions have the value of 7 */
  a=2, b=-3, c=5, d=-7, e=11, f=-3;
  printf("%d\n", a+=b+=c+=1+2);

  a=2, b=-3, c=5, d=-7, e=11, f=-3;
  printf("%d\n", a+=(b+=(c+=(1+2))));

  /* return successfully */
  return 0;
}
