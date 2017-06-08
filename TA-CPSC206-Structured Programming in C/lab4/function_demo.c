/*---------------------------------------------------------------------
 *  NAME:     function_demo.c
 *  AUTHOR:   Mu-Fen Hsieh
 *  DATE:     July 13, 2006
 *  PURPOSE:  A program which demonstrates the usage of functions in C.
 *            The program first asks for an integer from the user. Then
 *            it calls the first function to print the input number. Next
 *            it calls the second function to generate and print a 
 *            decreasing seris of 10 numbers, which starts with the 
 *            user-input integer. Finally it calls the third function to
 *            convert the user-input integer to a floating number. The 
 *            three functions have the same type of input variables but 
 *            different purposes and types of output. Three functions are 
 *            called sequentially from the main function and the outputs
 *            of the functions are printed to the screen. Also the execution
 *            flow of the program is shown with the output messages which
 *            begin with FLOW.
 *---------------------------------------------------------------------*/
#include <stdio.h>
#define TOTAL_NUM 10

/* function declaration */

void function1_print_num(int n);
int function2_decreasing_series(int n, int total_num);
float function3_convert_to_float(int n);

/* A program always starts executing with the main function */

int main(void) {
  /* variable declaration */

  int num;
  int last_num;
  float f;

  /* debugging message */

  printf("\nFLOW: Entering main function\n");
  printf("---------------------------------------------------------------------\n");

  /* ask for an integer from user */

  printf("Please enter an integer: ");
  scanf("%d",&num);

  /* call the first function */

  printf("---------------------------------------------------------------------\n");
  printf("FLOW: Prepare to call function1_print_num with the integer %d\n",num);
  function1_print_num(num);

  /* call the second function and print the function output */

  printf("---------------------------------------------------------------------\n");
  printf("FLOW: Prepare to call function2_decreasing_series with the integer %d\n",num);
  last_num = function2_decreasing_series(num,TOTAL_NUM);
  printf("\nThe last number of the decreasing series is %d\n",last_num);

  /* call the third function and print the function output */

  printf("---------------------------------------------------------------------\n");
  printf("FLOW: Prepare to call function3_convert_to_float with the same integer\n");
  f = function3_convert_to_float(num);
  printf("\nAfter converting to a floating number, the number becomes %f\n",f);

  /* debugging message */

  printf("---------------------------------------------------------------------\n");
  printf("FLOW: Leaving main function\n\n");

  /* return successfully */

  return 0;
}


/*---------------------------------------------------------------------
 *  NAME:     function1_print_num
 *
 *  PURPOSE:  Print the given integer
 *
 *  PARMS:    n: The integer to print
 *
 *  OUTPUT:   -
 *---------------------------------------------------------------------*/
void function1_print_num(int n) {
  /* debugging message */
  printf("FLOW: Entering function1_print_num with n=%d\n\n",n);

  /* the actual business of this function */
  printf("The number to print: %d\n\n",n);

  /* debugging message */
  printf("FLOW: Leaving function1_print_num\n");

  /* Since the output type of this function is void, do not return any value. */
}

/*---------------------------------------------------------------------
 *  NAME:     function2_decreasing_series
 *
 *  PURPOSE:  Print a random decreasing series of integers starting 
 *            with the given integer
 *
 *  PARMS:    n: The first number in the decreasing series
 *            total_num: Total number of integers we want to print
 *
 *  OUTPUT:   The last number in the decreasing series
 *
 *---------------------------------------------------------------------*/
int function2_decreasing_series(int n, int total_num) {
  /*
   * variable declaration:
   * Variables declared here cannot be seen from other
   * functions as well as from the main function, so
   * we can use duplicate names for variables in
   * individual function.
   */
  int count=0; //for counting the total integers generated

  /* debugging message */
  printf("FLOW: Entering function2_decreasing_series with n=%d, total_num=%d\n",n,total_num);
  
  /* start printing the decreasing series */
  printf("\n");
  printf("A decreasing series of %d integers starting with %d\n",TOTAL_NUM,n);

  printf("%d: %d\n",(count+1),n); //print the current integer
  ++count; //increment the total integers we've printed

  /* This loop will run for "total_num" iterations.
   * At each iteration, a smaller integer is generated and printed.
   */
  while (count < total_num) {

    n-=rand(); //substract the current integer by a random positive integer, including 0
    printf("%d: %d\n",(count+1),n); //print the current integer

    ++count; //increment the total integers we've printed
  }
  printf("\n");

  /* debugging message */
  printf("FLOW: Leaving function2_decreasing_series\n");

  /* Return the last number in the series */
  return n;
}

/*---------------------------------------------------------------------
 *  NAME:     function3_convert_to_float
 *
 *  PURPOSE:  Convert the input integer to a floating number
 *
 *  PARMS:    n: The integer to convert
 *
 *  OUTPUT:   A floating number which equals to the given integer
 *
 *---------------------------------------------------------------------*/
float function3_convert_to_float(int n) {
  /*
   * variable declaration:
   * Variables declared here cannot be seen from other 
   * functions as well as from the main function, so
   * we can use duplicate names for variables in 
   * individual function.
   */
  float f;

  /* debugging message */
  printf("FLOW: Entering function3_convert_to_float with n=%d\n",n);

  /* debugging message */
  printf("FLOW: Convert the integer n to a floating number f\n");

  /* the actual business of this function */
  f=(float)n;

  /* debugging message */
  printf("FLOW: Leaving function3_convert_to_float\n");

  /* return the floating number converted from n */
  return f;
}
/*-------------------------A POSSIBLE OUTPUT----------------------------- 
 *  FLOW: Entering main function
 *  ---------------------------------------------------------------------
 *  Please enter an integer: 1732487
 *  ---------------------------------------------------------------------
 *  FLOW: Prepare to call function1_print_num with the integer 1732487
 *  FLOW: Entering function1_print_num with n=1732487
 *  
 *  The number to print: 1732487
 *
 *  FLOW: Leaving function1_print_num
 *  ---------------------------------------------------------------------
 *  FLOW: Prepare to call function2_decreasing_series with the integer 1732487
 *  FLOW: Entering function2_decreasing_series with n=1732487, total_num=10
 *  
 *  A decreasing series of 10 integers starting with 1732487
 *  1: 1732487
 *  2: 1715649
 *  3: 1709891
 *  4: 1699778
 *  5: 1682263
 *  6: 1651212
 *  7: 1645585
 *  8: 1622575
 *  9: 1615156
 *  10: 1598944
 *
 *  FLOW: Leaving function2_decreasing_series
 *  
 *  The last number of the decreasing series is 1598944
 *  ---------------------------------------------------------------------
 *  FLOW: Prepare to call function3_convert_to_float with the same integer
 *  FLOW: Entering function3_convert_to_float with n=1732487
 *  FLOW: Convert the integer n to a floating number f
 *  FLOW: Leaving function3_convert_to_float
 *
 *  After converting to a floating number, the number becomes 1732487.000000
 *  ---------------------------------------------------------------------
 *  FLOW: Leaving main function
*/