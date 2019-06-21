/*
	This is a simulation for a boost comverter using Adams-Moulton method.
	System is as follows:
	
		di/dt = -200i - (U(v)/ 0.05) + 2000U
		dv/dt = - (5000/9)v +  ((i)U/ 0.00002)

	system is going to be aproximated on:
		0 <= t <= 0.1
	
	with initial conditions w0, w1, z0 and z1.
 */


#include <bits/stdc++.h>
using namespace std;

# define endl "\n"
typedef unsigned long long int ulli;

ulli n; 
long double w_, z_, w, z, t;
const long double U = 1;
const long double h = 0.05;

long double f(long double i, long double v){
	return -200 * i - (U * v/ 0.05) + 2000 * U;
}

long double g(long double i, long double v){
	return - (5000/9) * v +  (i * U/ 0.00002);
}

long double w_plus_one(long double wi, long double zi, long double wi_, long double zi_ ){

	return 0;
}

long double z_plus_one(long double wi, long double zi, long double wi_, long double zi_, long double wplus1){
	return 0;
}


void read_input(){
	cout << endl;

	cout << "Linear Differential System Equations will be approximated on the interval [" 
	<< 0 << ", " << 0.1 << "]." << endl <<
	"Now in order to use Adams-Moulton Method please insert N (to divide interval in N equally spaced numbers) " << endl;
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

	oi << t << " " << w_ << endl;
	ov << t << " " << z_ << endl;
	
	for(ulli i = 1; i < n; i++){

		t = t + h;
		oi << t << " " << w << endl;
		ov << t << " " << z << endl;

		long double aw = w, az = z;
		w = w_plus_one(aw, az, w_, z_);
		z = z_plus_one(aw, az, w_, z_, w);
		w_ = aw; z_ = az;
	}

	t = t + h;
	oi << t << " " << w << endl;
	ov << t << " " << z << endl;

	oi.close(); ov.close();
	return 0;
}