/* Author: Mu-Fen Hsieh
 * Date: July 12, 2006
 * File Name: as3.c
 * Description: A sample program for the assignment 3
 */
#include <stdio.h>

#define SINGLE 'S'
#define MARRIED 'M'
#define MARRIED_FILING_JOINTLY 'J'
#define STANDARD_DEDUCTION 3000
#define EXEMPTION_AMOUNT 1000
#define MAX_NUM_EXEMPTIONS 12
#define MIN_NUM_EXEMPTIONS 0

int main(void) {

  /*=== User-input variables ===*/

  int taxpayer_id;
  char filing_status[2]; // must be 'S', 'M' or 'J'
  float gross_income;    // can be < 0
  int num_exemptions;    // should be between 0 and 12

  /*=== Calculated variables ===*/

  float taxable_income; // = gross income - standard deduction (3000)
                        //   - 1000 * number of exemptions
                        // , should be > 0
  float tax_rate;       // calculated based on the taxable income 
                        // and the filing status
  float tax;            // = taxable income * tax rate

  /*=== Statistics variables ===*/

  int num_taxpayers=0;
  float sum_tax=0;
  float max_tax=0;
  int taxpayer_id_with_max_tax;

  /*=== Getting data of one taxpayer at each iteration ===*/

  while (1) {

    printf("Please enter the following data");
    printf(" or type any non-numeric character to exit.\n");

    /*=== Input taxpayer ID ===*/

    printf("Taxpayer ID (social security #): ");
    if (scanf("%d", &taxpayer_id) != 1)
      break;

    /*=== Input filing status ===*/

    printf("Filing status (S for single, M for married, ");
    printf("J for married filing jointly): ");
    
    // scan a string of length 1
    if (scanf("%1s", filing_status) != 1) {
      printf("\n*Wrong filing status.\n\n");
      continue;
    }
    
    if (filing_status[0]!=SINGLE && 
      filing_status[0]!=MARRIED && 
      filing_status[0]!=MARRIED_FILING_JOINTLY) {
      printf("*Wrong filing status.\n\n");
      continue;
    }

    /*=== Input gross income ===*/

    printf("Gross income: ");
    if (scanf("%f", &gross_income) != 1) {
      // consume all remaining characters held up in standard input
      scanf("%*s");
      
      printf("*Error in the gross income.\n\n");
      continue;
    }

    /*=== Input # of exemptions ===*/

    printf("Number of exemptions: ");
    if (scanf("%d", &num_exemptions) != 1) {
      // consume all remaining characters held up in standard input
      scanf("%*s");
      
      printf("*Error in the number of exemptions.\n\n");
      continue;
    }
    
    if (num_exemptions > MAX_NUM_EXEMPTIONS || 
      num_exemptions < MIN_NUM_EXEMPTIONS) {
      printf("*The number of exemptions should be between %d and %d.\n\n",
             MIN_NUM_EXEMPTIONS, MAX_NUM_EXEMPTIONS);
      continue;
    }

    /*=== Calculate taxable income ===*/

    taxable_income = gross_income - STANDARD_DEDUCTION 
                     - EXEMPTION_AMOUNT * num_exemptions;
    if (taxable_income < 0)
      taxable_income=0;

    /*=== Calcualte tax rate ===*/

    switch(filing_status[0]) {

    case SINGLE:
      if (taxable_income < 5000)
        tax_rate=0.15;
      else if (taxable_income > 20000)
        tax_rate=0.31;
      else
        tax_rate=0.22;
      break;

    case MARRIED:
      if (taxable_income < 10000)
        tax_rate=0.15;
      else if (taxable_income > 40000)
        tax_rate=0.31;
      else
        tax_rate=0.22;
      break;

    case MARRIED_FILING_JOINTLY:
      if (taxable_income < 7000)
        tax_rate=0.17;
      else if (taxable_income > 25000)
        tax_rate=0.33;
      else
        tax_rate=0.24;
      break;

    } // end of switch(filing_status[0])

    /*=== Calculate tax ===*/

    tax = taxable_income * tax_rate;

    /*=== Output the data of this taxpayer ===*/

    printf("\n");
    printf("Taxpayer ID: %d\n",taxpayer_id);
    printf("Filing Status: %c\n",filing_status[0]);
    printf("Gross Income: %.2f\n",gross_income);
    printf("Number of Exemptions: %d\n",num_exemptions);
    printf("Taxable Income: %.2f\n",taxable_income);
    printf("Tax Rate: %.2f\n",tax_rate);
    printf("Total Tax: %.2f\n",tax);
    printf("\n");

    /*=== Record the highest tax so far ===*/

    if (tax > max_tax) {
      max_tax = tax;
      taxpayer_id_with_max_tax = taxpayer_id;
    }

    /*=== Record # of taxpayers and the sum of total tax ===*/

    ++num_taxpayers;
    sum_tax += tax;

  } // end of while(1)

  printf("\n\n...End of inputting data.\n\n");

  /*===  Summary report ===*/

  printf("********** Summary **********\n\n");
  printf("# of taxpayers processed: %d\n",num_taxpayers);
  if (num_taxpayers == 0) {
    printf("The average tax amount: 0\n");
    printf("The taxpayer ID with the highest tax amount: \n");
  } else {
    printf("The average tax amount: %.2f\n",sum_tax/num_taxpayers);
    printf("The taxpayer ID with the highest tax amount: %d\n",
           taxpayer_id_with_max_tax);
  }
  printf("The highest tax amount: %.2f\n",max_tax);
  printf("\n");

  return 0;
}
