/*
	This is a simulation for a boost comverter using Adams-Moulton method.
	System is as follows:
	
		di/dt = -200i - (U(v)/ 0.05) + 2000U
		dv/dt = - (5000/9)v +  ((i)U/ 0.00002)

	system is going to be aproximated on:
		
		0 <= t <= 0.1

	divided in 2000 equal sub intervals, with initial conditions w0, w1, z0 and z1.
 */


#include <bits/stdc++.h>
using namespace std;

# define endl "\n"
typedef unsigned long long int ulli;


long double w_, z_, w, z, t;
const long double U = 1;
const long double h = 5e-5;
const ulli n = 2000; 

long double f(long double i, long double v){
	return -200 * i - (U * v/ 0.05) + 2000 * U;
}

long double g(long double i, long double v){
	return - (5000/9) * v +  (i * U/ 0.00002);
}

long double w_plus_one(long double wi, long double zi, long double wi_, long double zi_ ){
	long double teta = f(wi, zi)/30000 - 5e-5*f(wi_, zi_)/12;
	long double phi = g(wi, zi)/30000 - 5e-5*g(wi_, zi_)/12;
	return(
		252760800*wi/253922420 - 432*zi/1053620 - 432*phi/1053620 + 0.041476053 +  252760800*teta/253922420
	);
}

long double z_plus_one(long double wi, long double zi, long double wi_, long double zi_, long double wplus1){
	long double phi = g(wi, zi)/30000 - 5e-5*g(wi_, zi_)/12;
	return (
		432*zi/437 + 450*wplus1/437 + 432*phi/437
	);
}


void read_input(){
	cout << endl;

	cout << "Linear Differential System Equations will be approximated on the interval [" 
	<< 0 << ", " << 0.1 << "]. this interval is going to be devided in 2000 sub intervals" << endl;
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