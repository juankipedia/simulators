function [T,X] = plotingArea()
    clear all
    close all
    global u
    
    tspan = [0 0.1];
    x0=[1 1]*0;
    u=1;
    [T,X] = ode45(@secondOrder,tspan,x0);
    plot(T,X(:,1))
end


