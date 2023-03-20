phi = 0:pi/200:2*pi;

x = 3*sin(phi);
y = 3*cos(phi);

xx = -5:0.1:0;
yy = 3*xx + 3*sqrt(10);

plot(x,y,xx,yy)
grid on
axis equal
