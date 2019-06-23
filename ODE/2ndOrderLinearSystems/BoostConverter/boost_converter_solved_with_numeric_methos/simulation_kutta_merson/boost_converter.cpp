/*
	This is a simulation for a boost converter using Kutta-Merson method.
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
long double a, b, I, V, w, z, t, h, we, ze;
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
	"Now in order to use Kutta-Merson Method please insert N (to divide interval in N + 1 equally spaced numbers) " << endl;
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

 	std::ofstream oe;
 	oe.open ("errorsData.txt");

	t = a; w = I; z = V; h = (b - a)/ n; we = w; ze = z;


	oi << t << " " << w << endl;
	ov << t << " " << z << endl;
	oe << t << " " << 0 << " " << 0 << endl;
	
	for(ulli i = 1; i <= n; i++){

		long double k1 = h * f(w,z);
		long double l1 = h * g(w,z); 
		
		long double k2 = h * f(w + k1 / 3, z + l1 / 3);
		long double l2 = h * g(w + k1 / 3, z + l1 / 3);

		long double k3 = h * f(w + k1/6 + k2/6, z + l1/6 + l2/6);
		long double l3 = h * g(w + k1/6 + k2/6, z + l1/6 + l2/6);
		
		long double k4 = h * f(w + k1/8 + 3*k3/8, z + l1/8 + 3*l3/8);
		long double l4 = h * g(w + k1/8 + 3*k3/8, z + l1/8 + 3*l3/8); 

		long double k5 = h * f(w + k1/2 - 3*k3/2 + 2*k4, z + l1/2 - 3*l3/2 + 2*l4);
		long double l5 = h * g(w + k1/2 - 3*k3/2 + 2*k4, z + l1/2 - 3*l3/2 + 2*l4);

		w += k1/6 + 2*k4/3 + k5/6;
		z += l1/6 + 2*l4/3 + l5/6;

		we += k1/2 - 3*k3/2 + 2*k4;
		ze += l1/2 - 3*l3/2 + 2*l4;

		t = t + h;
		
		oi << t << " " << w << endl;
		ov << t << " " << z << endl;
		oe << t << " " << 0.2*abs(we - w) << " " << 0.2*abs(ze - z) << endl;
	}

	oi.close(); ov.close(); oe.close();
	return 0;
}