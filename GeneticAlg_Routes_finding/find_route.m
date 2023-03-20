function [route, grid, power] = find_route(grid_in, route_in, i, power_in)
route = route_in;
grid = grid_in;
power = power_in;
N = size(route,1);

if i==N
    for k=1:size(grid,1)
        for l=1:size(grid,2)
            route_in(i,:) = [k,l];
            [power_x, clusters_x, grid_x] = calc_power(grid,route_in);
            distance = calc_distance(route_in);
            if (power_x < power) && (distance < 2*size(route_in,1))
                route = route_in;
                power = power_x;
                grid = grid_x;
            end
        end
    end
else
    if i<3
        disp(route_in)
    end
    for k=1:size(grid,1)
        for l=1:size(grid,2)
            route_in(i,:) = [k,l];
            [route_x, grid_x, power_x] = find_route(grid_in, route_in, i+1, power);
            if (power_x < power) && (calc_distance(route_in < 2*size(route_in,1)))
                route = route_x;
                power = power_x;
                grid = grid_x;
            end
        end
    end
end
