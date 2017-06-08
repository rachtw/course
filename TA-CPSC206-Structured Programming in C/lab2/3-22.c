/* Author: Mu-Fen Hsieh
 * Date: July 12, 2006
 * File Name: 3-22.c
 * Description: A sample program for Exercise 3-22
 */
#include <stdio.h>
int main(void) {
  int a=1,b=2,c=3,d=4;
  printf("%d\n",a&&b&&c);
  a=1,b=2,c=3,d=4;
  printf("%d\n",(a&&b)&&c);
  
  a=1,b=2,c=3,d=4;
  printf("%d\n",a&&b||c);
  a=1,b=2,c=3,d=4;
  printf("%d\n",(a&&b)||c);
  
  a=1,b=2,c=3,d=4;
  printf("%d\n",a||b&&c);
  a=1,b=2,c=3,d=4;
  printf("%d\n",a||(b&&c));
  
  a=1,b=2,c=3,d=4;
  printf("%d\n",a||!b&&!!c+4);
  a=1,b=2,c=3,d=4;
  printf("%d\n",a||((!b)&&((!(!c))+4)));
  
  a=1,b=2,c=3,d=4;
  printf("%d\n",a+=!b&&c==!5);
  a=1,b=2,c=3,d=4;
  printf("%d\n",a+=((!b)&&(c==(!5))));
  
  return 0;
}
