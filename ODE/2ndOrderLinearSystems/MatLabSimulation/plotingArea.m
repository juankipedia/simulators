function [T,X] = plotingArea()
    tspan = [0 5];
    x1_0 = 2;
    x2_0 = 0;
    [T,X] = ode23(@secondOrder,tspan,[x1_0 x2_0]);
    plot(X(:,1),X(:,2))
end