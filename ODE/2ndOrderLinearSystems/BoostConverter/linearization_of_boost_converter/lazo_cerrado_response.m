H = [tf([-1799 -2001044.444 -8000000/9],[1 (-9382/9) (-8002600/9) 2000000/9])];
[u,t] = gensig('pulse',4,5,0.2);
lsim(H,u,t)