# include <iostream>
# include <iomanip>
# include <fstream>
# include <cmath>

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
    this equation has an explicit solution:
        
        A = Ce^(-rt)

    given the initial condition A(0) = 10000000 we have:
        A = (10000000)e^(-rt)
    this equation is use belong to model the bottle.
*/
int main() { 
    std::ofstream data;
    data.open("wb.txt");
    long double x, c = 10000000L, r = 0.1L, a, t = 0.0L;

    for (size_t i = 0; i <= 5000; ++i){
    	data << std::fixed << t << " " << c * exp(-r * t) << std::endl;
    	t += 0.01L;
    }

    data.close();
    return 0; 
} 