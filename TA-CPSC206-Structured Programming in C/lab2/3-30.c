/* Author: Mu-Fen Hsieh
 * Date: July 12, 2006
 * File Name: 3-30.c
 * Description: A sample program for Exercise 3-30
 */
#include <stdio.h>
int main(void) {
  double number;
  int count=0;
  double runningTotal=0;

  // initialization before first loop iteration
  printf("Type some numbers, the last one being 0\n");
  scanf("%lf",&number);
  while (number!=0) {
    runningTotal = runningTotal + number;
    count=count+1;
    //prepare for next iteration
    scanf("%lf",&number);
  }
  printf("The average of the %d numbers is %f\n",count, runningTotal/count);

  return 0;
}
