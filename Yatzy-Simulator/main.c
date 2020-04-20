#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <stdbool.h>
#include <string.h>

#include "yatzy.h"

int score_board[1000];
int current_game = 0;

// helper function to print an array
void print_array(int N, int* dice_rolls) {
	printf("[");
	for (int i = 0; i < N; i++) {
		if (i)
			printf(",");
		printf("%d", dice_rolls[i]);
	}
	printf("]\n");
} 


// checks if two strings are equal
bool is_equal(const char* a, const char* b)
{
	return strcmp(a,b) == 0;
}

// checks if a string is not a number
bool no_conversion(int x, const char* str)
{
	return x == 0 && !isdigit(str[0]);
}

int main()
{

    while (true)	// start the game
    {
        char buffer[100];	// to handle the input

        printf("Enter a number of dices: ");

        int N;
		int bonus = 0;

		while (scanf("%s", buffer) != EOF) {	// ask the user for the number of dice
			N = atoi(buffer);
			if (no_conversion(N, buffer))		
				printf("is not a number, plese enter again\n");
			else {
				if (N < 5)
					printf("the number must be >= 5, please enter again\n");
				else
					break;
			}
		}
        
        int score = 0;
        int dices[N];

		getchar();	// eats the last break line

		for (int i = 1; i <= 15; i++) {	// there are 15 rounds in every game
			roll_multiple_dice(N, dices);	// roll the dices
			switch(i) {
				case 1 : {
					printf("1s round: ");
					score += ones(N, dices); 
					break;
				}
				case 2 : {
					printf("2s round: ");
					score += twos(N, dices); 
					break;
				}
				case 3 : {
					printf("3s round: ");
					score += threes(N, dices); 
					break;
				}
				case 4 : {
					printf("4s round: ");
					score += fours(N, dices); 
					break;
				}
				case 5 : {
					printf("5s round: ");
					score += fives(N, dices);
					if(score >= 63 && bonus == 0){
						printf("\nYou get a bonus of 50 for reaching at least 63 points in first 5 rounds\n");
						bonus = 1;
						score += 50;
					}	
					break;
				}
				case 6 : {
					printf("6s round: ");
					score += sixes(N, dices);
					if(score >= 63 && bonus == 0){
						printf("\nYou get a bonus of 50 for reaching at least 63 points in first 6 rounds\n");
						bonus = 1;
						score += 50;
					}	
					break;
				}
				case 7 : {
					printf("One pair round: ");
					score += one_pair(N, dices); 
					break;
				}
				case 8 : {
					printf("Two pair round: ");
					score += two_pairs(N, dices); 
					break;
				}
				case 9 : {
					printf("Three of a kind round: ");
					score += three_of_a_kind(N, dices); 
					break;
				}
				case 10 : {
					printf("Four of a kind round: ");
					score += four_of_a_kind(N, dices); 
					break;
				}
				case 11 : {
					printf("Small straight round: ");
					score += small_straight(N, dices); 
					break;
				}
				case 12 : {
					printf("Large straight round: ");
					score += large_straight(N, dices); 
					break;
				}
				case 13 : {
					printf("Full house round: ");
					score += full_house(N, dices); 
					break;
				}
				case 14 : {
					printf("Chance round: ");
					score += chance(N, dices); 
					break;
				}
				case 15 : {
					printf("Yatzy round: ");
					score += yatzy(N, dices);
				}
			}
			
			print_array(N, dices);
			printf("Score: %d\n\n", score);
		}

		score_board[current_game++] = score;

        printf("do you want to play again? (y/n): ");

        while (scanf("%s", buffer) != EOF) {	// ask the user to continue
		if (!is_equal(buffer,"n") && !is_equal(buffer,"N") && !is_equal(buffer,"y") && !is_equal(buffer,"Y")) 
			printf("invalid answer, please enter again: ");
            	else
			break;
        }
        
        if (is_equal(buffer, "n") || is_equal(buffer, "N"))
			break;
    }

	puts("Game overview (scores):");
	print_array(current_game, score_board);
    puts("Thanks for playing!");

    return 0;
}
