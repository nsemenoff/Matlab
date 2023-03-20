function res = calc_distance(route)

res = 0;
x_old = route(1,1);
y_old = route(1,2);
for i=2:size(route,1)
    x = route(i,1);
    y = route(i,2);
    res = res + sqrt( (x-x_old)^2 + (y-y_old)^2 );
    x_old = x;
    y_old = y;
end

% x = route(1,1);
% y = route(1,2);
% res = res + sqrt( (x-x_old)^2 + (y-y_old)^2 );

