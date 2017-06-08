#include <stdio.h>
#define NUM_EXAMS 4
#define NUM_STUDENTS 5
char *num[] = {"1st", "2nd", "3rd", "4th", "5th"};

int load_array(int scores[NUM_STUDENTS][NUM_EXAMS]) {
  int i,j,score;

  for (i=0; i<NUM_STUDENTS; i++) {
    do {
      printf("Please enter 4 exam scores for the %s student. The scores should be seperated by space.\n", num[i]);
      for (j=0; j<NUM_EXAMS; j++) {
	if (scanf("%d",&score)!=1)
	  return -1;
	if (score > 100 || score < 0)
	  break;
	scores[i][j]=score;
      }
    } while (j!=NUM_EXAMS);
  }
  return 0;
}

void output_data(int scores[NUM_STUDENTS][NUM_EXAMS]) {
  int i,j;

  printf(" ");
  for (j=0; j<NUM_EXAMS; j++)
    printf("%5d", j+1);
  printf("... Exams\n");

  for (i=0; i<NUM_STUDENTS; i++) {
    printf("%d", i+1);
    for (j=0; j<NUM_EXAMS; j++)
      printf("%5d", scores[i][j]);
    printf("\n");
  }
  printf(".\n.\n.\nS\nt\nu\nd\ne\nn\nt\ns\n");
}

void student_avg(int scores[NUM_STUDENTS][NUM_EXAMS]) {
  int i,j,sum;

  for (i=0; i<NUM_STUDENTS; i++) {
    sum = 0;
    for (j=0; j<NUM_EXAMS; j++)
      sum += scores[i][j];
    printf("The average of the %s student: %5.2f\n", num[i], ((float) sum) / NUM_EXAMS);
  }
}

void exam_avg(int scores[NUM_STUDENTS][NUM_EXAMS]) {
  int i,j,sum;

  for (j=0; j<NUM_EXAMS; j++) {
    sum = 0;
    for (i=0; i<NUM_STUDENTS; i++)
      sum += scores[i][j];
    printf("The average of the %s exam: %5.2f\n", num[j], ((float) sum) / NUM_STUDENTS);
  }
}

int main(void) {
  //int scores[NUM_STUDENTS][[NUM_EXAMS];
  int scores[5][4];

  if (load_array(scores) < 0) {
    printf("Error in loading the data\n");
    return -1;
  }

  output_data(scores);

  student_avg(scores);

  exam_avg(scores);

  return 0;
}
