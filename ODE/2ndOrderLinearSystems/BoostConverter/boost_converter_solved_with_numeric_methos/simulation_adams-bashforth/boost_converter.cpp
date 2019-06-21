/*
	This is a simulation for a boost comverter using Adams-Bashforth method.
	System is as follows:
	
		di/dt = -200i - (U(v)/ 0.05) + 2000U
		dv/dt = - (5000/9)v +  ((i)U/ 0.00002)

	system is going to be aproximated on:
		a <= t <= b
	
	with initial conditions w0, w1, z0 and z1.
 */


#include <bits/stdc++.h>
using namespace std;

# define endl "\n"
typedef unsigned long long int ulli;

ulli n; 
long double a, b, w_, z_, w, z, t, h;
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
	"Now in order to use Adams-Bashforth Method please insert N (to divide interval in N equally spaced numbers) " << endl;
	cin >> n;
	cout << endl;
	
	cout << "Please Insert Initial condition for the Current w0" << endl;
	cin >> w_;
	cout << endl;

	cout << "Please Insert Second condition for the Current w1" << endl;
	cin >> w;
	cout << endl;

	cout << "Please Insert Initial condition for the Voltage z0" << endl;
	cin >> z_;
	cout << endl;

	cout << "Please Insert Initial condition for the Voltage z1" << endl;
	cin >> z;
	cout << endl;
}

int main(){

	read_input();

	std::ofstream oi;
 	oi.open ("currentData.txt");

	std::ofstream ov;
 	ov.open ("voltageData.txt");

	t = a; h = (b - a)/ n;


	oi << t << " " << w_ << endl;
	ov << t << " " << z_ << endl;
	
	for(ulli i = 1; i < n; i++){

		t = t + h;
		oi << t << " " << w << endl;
		ov << t << " " << z << endl;

		long double aw = w, az = z;
		w = aw + h * (3 * f(aw, az) - f(w_, z_)) / 2;
		z = az + h * (3 * g(aw, az) - g(w_, z_)) / 2;;
		w_ = aw; z_ = az;
	}

	t = t + h;
	oi << t << " " << w << endl;
	ov << t << " " << z << endl;

	oi.close(); ov.close();
	return 0;
}