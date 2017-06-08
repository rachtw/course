/* Author: Mu-Fen Hsieh
 * Date: July 12, 2006
 * File Name: 3-31.c
 * Description: A sample program for Exercise 3-31
 */
#include<stdio.h>
#include<math.h>
int main(void) {
  int n;
  while (1) {
    printf("Enter a positive integer or 0 to exit:");
    scanf("%d",&n);
    if (n==0) break; //exit loop if n is 0
    if (n<0) continue; //wrong value
    printf("squareroot of %d = %f\n",n,sqrt(n));
    //continue land here at end of current iteration
  }
  //break lands here
  printf("a zero was entered\n");
  return 0;
}
