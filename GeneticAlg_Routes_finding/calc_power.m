function [res, clusters, new_grid] = calc_power(grid, route)
res = 0;
clusters = zeros(size(route,1),1);
new_grid = grid;

for i=1:size(grid,1)
    for j=1:size(grid,2)
        dist = zeros(size(route,1)-1,1);
        for k=1:size(route,1)-1
            dist(k) = abs(i-route(k,1)) + abs(j-route(k,2));
        end
        [m,idx] = min(dist); % ближайший референсный агент
        res = res + m;
        clusters(idx) = clusters(idx) + 1;
        new_grid(i,j) = idx;
    end
end
