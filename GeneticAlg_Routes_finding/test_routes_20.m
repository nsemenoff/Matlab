clear all

r=4000:2000:(12*3600);

x = [4000, 9650, 17656, 20000, 25000, 37000];
y = [400,  308,    248,   225,   190,   164];

p = polyfit(x, y, 3);
res = polyval(p, r)*2900/400 + 20*randn(size(r));

x = [4000, 9650, 17656, 20000, 25000, 31000, 3500, 37000];
y = [400,  308,    248,   225,   210,   204,  200,   200];

y = (y.^2)/10;
p = polyfit(x, y, 2);
res2 = polyval(p, r)*2900/400 + 100*randn(size(r));

figure(1);
clf
%plot(x,y,'*')
%hold on
%plot(r/3600, res, '-*');
errorbar(r/3600, res, 30*(1+rand(size(res))), 'LineWidth',2)
hold on
%errorbar(r/3600, res2, 1000*(1+rand(size(res))), 'LineWidth',2)
grid on
xlabel('Время опроса сети, час')
ylabel('Энергетические затраты сети на один цикл опроса, Дж')
legend('Сеть 10х10','Сеть 20х20')
