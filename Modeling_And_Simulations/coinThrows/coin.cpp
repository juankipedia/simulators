# include <bits/stdc++.h>

/*
	Author: Juan Diego M. Flores.

	Simulate the throws of a regular coin 5 times and calculate the probability of 
	getting 4 Faces in 5 throws. Perform the process for N times and compare it with 
	the result given by the binomial distribution.

	Probability of getting 4 Faces in 5 throws = (number of favorable cases) / (total number of cases)
*/

int main(){
	
	long double counter = 0, N; 
	short faces = 0;
	srand(time(NULL));
	

	std::cin >> N;

	for (int i = 0; i < N; ++i){
		//generate 5 random throws of the coin by generating 0 or 1 randomly, 5 times
		faces = 0;
		for (int j = 0; j < 5; ++j)
			if(rand() % 2 == 1) faces ++;	
		if(faces == 4)
			counter += 1;
	}

	std::cout << std::fixed << counter / N << std::endl;

	return 0;
}