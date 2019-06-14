/*
	This is a simulation for a boost comverter using Runge Kutta method.
	Linear System is as follows:
	
		di/dt = (-200)i - (20)v - (1800)U
		dv/dt = (5e4)i - (5000/9)v + (5e4)U

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
const long double U = 0.5;

long double f(long double i, long double v){
	return -200 * i - 20 * v - 1800 * U;
}

long double g(long double i, long double v){
	return 5e4 * i - (5000/9) * v + 5e4 * U;
}

int main(){
	cout << endl;
	
	cout << "Please Insert Lower Bound" << endl;
	cin >> a;
	cout << endl;
	
	cout << "Please Insert Upper Bound" << endl;
	cin >> b;
	cout << endl;
	
	cout << "Linear Differential System Equations will be approximated on the interval [" 
	<< a << ", " << b << "]." << endl <<
	"Now in order to use Runge Kutta Method please insert N (to divide interval in N + 1 equally spaced numbers) " << endl;
	cin >> n;
	cout << endl;
	
	cout << "Please Insert Initial condition for the Current I(0)" << endl;
	cin >> I;
	cout << endl;

	cout << "Please Insert Initial condition for the Voltage V(0)" << endl;
	cin >> V;
	cout << endl;

	t = a; w = I; z = V; h = (b - a)/ n;

	vector<pair<long double, long double>> it;
	vector<pair<long double, long double>> vt;
	
	it.push_back(make_pair(t, w));
	vt.push_back(make_pair(t, z));
	
	for(ulli i = 1; i <= n; i++){

		long double k1 = h * f(w,z);
		long double l1 = h * g(w,z); 
		
		long double k2 = h * f(w + k1 / 2, z + l1 / 2);
		long double l2 = h * g(w + k1 / 2, z + l1 / 2);

		long double k3 = h * f(w + k2 / 2, z + l2 / 2);;
		long double l3 = h * g(w + k2 / 2, z + l2 / 2);
		
		long double k4 = h * f(w + k3, z + l3);
		long double l4 = h * g(w + k3, z + l3);  

		w = w + (k1 + 2 * k2 + 2 * k3 + k4)/6;
		z = z + (l1 + 2 * l2 + 2 * l3 + l4)/6;

		t = a + i * h;
		
		it.push_back(make_pair(t, w));
		vt.push_back(make_pair(t, z));
	}


	return 0;
}