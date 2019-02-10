function xdot = secondOrder(t,x)
global u 
xdot(1)= -200*x(1) - 20*x(2) -1800*u;
xdot(2)= 50000*x(1) - (5000/9)*x(2) + 50000*u;
xdot =xdot';