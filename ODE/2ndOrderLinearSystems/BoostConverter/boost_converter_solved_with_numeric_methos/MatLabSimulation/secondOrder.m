function xdot = secondOrder(t,x)
global u 
xdot(1)= -200*x(1) + 0*x(2) - x(2) * u /0.05 + 2000;
xdot(2)= 0*x(1) - (5000/9)*x(2) + x(1)*u/0.00002;
xdot =xdot';