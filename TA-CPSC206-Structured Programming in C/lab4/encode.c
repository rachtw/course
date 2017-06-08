#include <stdio.h>
#include <ctype.h>
#include <string.h>
#define NUM_ALPHA 26
#define FALSE 0
#define TRUE 1
int main(void) {
  int i; //iterator, counter
  char key[NUM_ALPHA];  // substitution key
  int letter_occurrence[NUM_ALPHA]; /* It's an array of boolean variables
                                      which records whether the letter has 
                                      occurred in the key */
  char input_char;  // current input character

  // Print letters A to Z
  printf("Letters:             ");
  for (i=0; i<NUM_ALPHA; i++)
    printf("%c", 'A'+i);
  printf("\n");

  /*
   * Ask user to input a substitution key
   */
  do {  
    // Initialize the boolean array to be false
    for (i=0; i<NUM_ALPHA; i++)
      letter_occurrence[i] = FALSE;
      
    // Set counter to be 0
    i = 0;
      
    printf("Enter coded letters: ");

    // While not reaching a newline symbol, keep reading input
    while ((input_char=getchar())!='\n') {
      if (i > NUM_ALPHA) {
        printf("You have entered a non-alphabetic character\n");
        break;
      }
      
      // If the current input character is not an alphabet
      if (!isalpha(input_char)) {
        printf("You have entered a non-alphabetic character\n");
        break;
      }

      /* The current input character is an alphabet,
         so convert it to upper-case */
      input_char = toupper(input_char);

      // If the current character has occurred previously...
      if (letter_occurrence[input_char-'A']) {
        printf("You have entered a duplicated character: %c\n", input_char);
        break;
      }

      // Set the occurrence of the current character to be true
      letter_occurrence[input_char-'A'] = TRUE;

      // Store the current character to the key array
      key[i]=input_char;

      // Increment the counter
      i++;
    }
    if (i > NUM_ALPHA)
      printf("You have entered more than 26 characters\n");    
  } while (i!=NUM_ALPHA); /* While the counter is not incremented to 26, 
                             continue to execute the loop */  

  /*
   * Ask user to input a text
   */
  printf("Input line:          ");
  while ((input_char=getchar())!='\n') {
    
    // If the current reading character is an alphabet,
    if (isalpha(input_char))
    
      /* use upper case of the current character 
         to calculate the index of its coded letter. */
      putchar(key[toupper(input_char)-'A']);
      
    // Otherwise,
    else
    
      // print the unchanged character.
      putchar(input_char);
  }
  putchar('\n');

  return 0;
}
