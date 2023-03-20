clear all
close all

N=10; % 10x10 (NxN)
max_len = 4; % route len

fld = zeros(N,N);
test = 1;

route_in = zeros(4,2);
power_in = 1e6;
grid_in = zeros(N,N);
[route, grid, power] = find_route(grid_in, route_in, 1, power_in);

fig1 = figure;
clf

xx = route(:,1);
yy = route(:,2);
plot(xx,yy,'LineWidth',2);
hold on
legend_text = [num2str(calc_distance(route)*1000/3600, 'Период опроса %7.4f часов'), ', затраты энергии ', num2str(old_power/1.1, '%7.4f кДж')];
title(legend_text);

colors = ['rgbcmykrgbcmykrgbcmykrgbcmykrgbcmykrgbcmykrgbcmykrgbcmykrgbcmykrgbcmykrgbcmykrgbcmykrgbcmyk'];
for i=1:N
    for j=1:N
        plot(i,j,[colors(grid(i,j)) '*']);
        %                hold on
    end
end
drawnow;

img_name = ['Result_' num2str(max_len) '_' num2str(test) '.jpg'];
disp(img_name)
saveas(fig1, img_name);

pwr = calc_power(fld, route);
disp([num2str(max_len,'%02d') ', ' num2str(calc_distance(route),'%05.2f, ') ' ' num2str(pwr)])

