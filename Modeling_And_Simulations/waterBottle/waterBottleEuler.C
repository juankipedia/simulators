# include <iostream>
# include <fstream>
using namespace std;


/* 
    Author: Juan Diego M. Flores

    Description: A bottle full of water has an outlet valve on the bottom. When the valve opens, the
    Water flows and falls to the ground. The rate at which the water comes out is larger 
    at the beginning because the Water pressure in the bucket pushes the water down. As 
    the bottle empties, the pressure decreases and consequently also the exit rate. This 
    is an example of exponential decrease. The rate of emptying the bucket is proportional
    to the amount of water that There is still e bucket. The equation that governs this 
    behavior would be:
    
        dA(t)/dt = -rA(t)
    
    where A is the volume on the bottle and r the exit rate.
    this model is solved by Eulers Method:
    	given an interval [a, b], an equation A' = f(t,A),
    	an initial condition A(a) and a number of steps N we have:
    		step 1: take h = (b - a) / N;
    				t = a;
    				w = A(a);
    				out(t, w);
    		step 2: for i = 1, 2, ..... N, execute steps 3,4.
    		step 3: make w = w + h * f(t, w)   (value of wi)
    					 t = a + ih            (value of ti)
    		step 4: out(t,w);
*/


int main(){

	ofstream data;
	data.open("wbe.txt");
	long double t = 0;
	size_t N = 500000;
	long double w = 10000000, a = 0L, b = 50.0L;
	long double h = (b - a) / static_cast<long double>(N);
	data << fixed << t << " " << w << endl;

	for (size_t i = 1; i <= N; ++i){
		t = a + h * i;
		w = w + h * (-0.1L * w);
		data << fixed << t << " " << w << endl;
	}

	data.close();
	return 0;
}