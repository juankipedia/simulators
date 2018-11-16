function xdot = secondOrder(~,x)
 xdot= [
    5*x(1) - x(2);
    3*x(1) + x(2);
];