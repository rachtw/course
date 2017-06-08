/*---------------------------------------------------------------------
 *  NAME:     days.c
 *  AUTHOR:   Mu-Fen Hsieh
 *  DATE:     July 26, 2006
 *  PURPOSE:  A program which compute the exact number of days beetween
 *            any two dates between year 1000 and year 9999
 *---------------------------------------------------------------------*/
#include <stdio.h>
#define DAYS_YEAR 365

/* Function Prototypes */
int daysmonth(int m,int y);
int isleapyear(int y);
int daysinsameyear(int m1, int d1, int m2, int d2, int y);

/* Constant Definition */
enum {JAN=1, FEB, MAR, APR, MAY, JUN, JUL, AUG, SEP, OCT, NOV, DEC};
enum {DAYS_JAN=31, DAYS_FEB=28, DAYS_MAR=31, DAYS_APR=30, 
      DAYS_MAY=31, DAYS_JUN=30, DAYS_JUL=31, DAYS_AUG=31, 
      DAYS_SEP=30, DAYS_OCT=31, DAYS_NOV=30, DAYS_DEC=31};

int main(void) {
  int d1,m1,y1,d2,m2,y2; //day, month, year in first and second dates
  int total=0;           //total # of days
  int i;                 //iterator
  char delim1,delim2;    //delimeters

  printf("Enter first date: ");

  /* Check the input format:
     (1) presence of three numbers seperated by delimeters
     (2) / used as delimeters
     (3) four digit year
     (4) month between 1 and 12
     (5) date within the actual number of days
  */
  while (scanf("%d%c%d%c%d",&m1,&delim1,&d1,&delim2,&y1)!=5 || 
	 delim1 != '/' || delim2 != '/' || 
	 y1 < 1000 || y1 > 9999 || 
	 m1 > DEC || m1 < JAN || 
	 d1 < 1 || d1 > daysmonth(m1,y1)) {
    printf("Error in the first date\n");
    printf("Enter first date: ");
  }
  
  printf("Enter second date: ");

  /* Check the input format:
     (1) presence of three numbers seperated by delimeters
     (2) / used as delimeters
     (3) four digit year
     (4) month between 1 and 12
     (5) date within the actual number of days
     (6) second date later than first date
  */
  while (scanf("%d%c%d%c%d",&m2,&delim1,&d2,&delim2,&y2)!=5 || 
	 delim1 != '/' || delim2 != '/' || 
	 y2 < 1000 || y2 > 9999 || 
	 m2 > DEC || m2 < JAN || 
	 d2 < 1 || d2 > daysmonth(m2,y2) ||
	 y1 > y2 || (y1==y2 && (m1 > m2 || (m1==m2 && d1 >= d2)))) {
    printf("Error in the second date\n");
    printf("Enter second date: ");
  }

  // The two dates are in the same year
  if (y1==y2)
    total = daysinsameyear(m1,d1,m2,d2,y2);

  // The two dates are in different years
  else {

    // # of days in first month
    total += daysmonth(m1,y1) - d1;

    // # of days from second month to Dec 31 of same year
    for (i = m1 + 1; i <= DEC; i++)
      total += daysmonth(i,y1);

    // # of days in intervening years
    for (i = y1 + 1; i < y2; i++)
      total += DAYS_YEAR + isleapyear(i);
    
    // # of days from Jan 1 of last year to second last month
    for (i = JAN; i < m2; i++)
      total += daysmonth(i,y2);

    // # of days in last month
    total += d2;
  }

  printf("There are %d days between the two dates.\n",total);

  return 0;
}

/*---------------------------------------------------------------------
 *  NAME:     daysmonth
 *  PURPOSE:  Return the number of days for the given month in the given year
 *  PARMS:    m: The month
 *            y: The year
 *  OUTPUT:   The number of days for the given month in the given year
 *---------------------------------------------------------------------*/
int daysmonth(int m,int y) {
  switch(m) {
  case JAN: return DAYS_JAN;
  case FEB: return DAYS_FEB + isleapyear(y);
  case MAR: return DAYS_MAR;
  case APR: return DAYS_APR;
  case MAY: return DAYS_MAY;
  case JUN: return DAYS_JUN;
  case JUL: return DAYS_JUL;
  case AUG: return DAYS_AUG;
  case SEP: return DAYS_SEP;
  case OCT: return DAYS_OCT;
  case NOV: return DAYS_NOV;
  case DEC: return DAYS_DEC;
  }
  return -1;
}

/*---------------------------------------------------------------------
 *  NAME:     isleapyear
 *  PURPOSE:  Return whether or not the given year is a leap year
 *  PARMS:    y: The year
 *  OUTPUT:   Is the year a leap year?
 *---------------------------------------------------------------------*/
int isleapyear(int y) {
  if (y % 400 == 0)    return 1;
  if (y % 100 == 0)    return 0;
  if (y % 4 == 0)    return 1;
  return 0;
}

/*---------------------------------------------------------------------
 *  NAME:     daysinsameyear
 *  PURPOSE:  Return the number of days between two dates in the same year
 *  PARMS:    m1, d1: Month & day in the first date
 *            m2, d2: Month & day in the second date
 *            y: Year
 *  OUTPUT:   The number of days between two dates in the same year
 *---------------------------------------------------------------------*/
int daysinsameyear(int m1, int d1, int m2, int d2, int y) {
  int i,total=0;

  // The two dates are in different months
  if (m1!=m2) {
    
    // # of days in first month
    total += daysmonth(m1,y) - d1;
    
    // # of days in intervening months
    for (i = m1 + 1; i < m2; i++)
      total += daysmonth(i,y);
      
    // # of days in last month
    total += d2;
    
  } 
  // The two dates are in same month
  else
    total = d2 - d1;

  return total;
}
