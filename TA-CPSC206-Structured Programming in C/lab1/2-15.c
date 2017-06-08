#include "2-15.h"
int main(void) {
  float f1, f2, f3;
  printf("Input three floating-point values\n");
  scanf("%f%f%f",&f1,&f2,&f3);
  printf("The average is %f\n",(f1+f2+f3)/3.0);
  return 0;
}
