/*
	This is a simulation for a boost comverter using Euler method.
	System is as follows:
	
		di/dt = -200i - (U(v)/ 0.05) + 2000U
		dv/dt = - (5000/9)v +  ((i)U/ 0.00002)

	system is going to be aproximated on:
		a <= t <= b
	
	with initial conditions I = i(0) and  V = v(0).
 */


#include <bits/stdc++.h>
using namespace std;

# define endl "\n"
typedef unsigned long long int ulli;

ulli n; 
long double a, b, I, V, w, z, t, h;
const long double U = 1;

long double f(long double i, long double v){
	return -200 * i - (U * v/ 0.05) + 2000 * U;
}

long double g(long double i, long double v){
	return - (5000/9) * v +  (i * U/ 0.00002);
}

void read_input(){
	cout << endl;

	cout << "Please Insert Lower Bound" << endl;
	cin >> a;
	cout << endl;
	
	cout << "Please Insert Upper Bound" << endl;
	cin >> b;
	cout << endl;
	
	cout << "Linear Differential System Equations will be approximated on the interval [" 
	<< a << ", " << b << "]." << endl <<
	"Now in order to use Euler Method please insert N (to divide interval in N + 1 equally spaced numbers) " << endl;
	cin >> n;
	cout << endl;
	
	cout << "Please Insert Initial condition for the Current I(0)" << endl;
	cin >> I;
	cout << endl;

	cout << "Please Insert Initial condition for the Voltage V(0)" << endl;
	cin >> V;
	cout << endl;
}

int main(){

	read_input();

	std::ofstream oi;
 	oi.open ("currentData.txt");

	std::ofstream ov;
 	ov.open ("voltageData.txt");

	t = a; w = I; z = V; h = (b - a)/ n;


	oi << t << " " << w << endl;
	ov << t << " " << z << endl;
	
	for(ulli i = 1; i <= n; i++){
 
		w += h * f(w, z);
		z += h * g(w, z);

		t = a + i * h;
		
		oi << t << " " << w << endl;
		ov << t << " " << z << endl;
	}

	oi.close(); ov.close();
	return 0;
}