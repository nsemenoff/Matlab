clear all
close all

N=10; % 10x10 (NxN)
max_len = 4; % route len

fld = zeros(N,N);
test = 1;

route_in = zeros(4,2);
power_in = 1e6;
grid_in = zeros(N,N);

GA_population = 2000;
GA_selection = 100;

%% Population

genes = zeros(GA_population, 2*max_len);
for i=1:GA_population
    goodRoute = true;
    while goodRoute
        route = [randi(N,1,max_len); randi(N,1,max_len)]';
        route(end,:) = route(1,:);
        goodRoute = ( calc_distance(route) > max_len*2 );
    end 
    genes(i,:) = route(:);
end

max_epochs = 1000;
while max_epochs>0
    max_epochs = max_epochs - 1;
    %% Selection
    power = zeros(1,GA_population);
    for i=1:GA_population
        gene = reshape(genes(i,:),max_len,2);
        power(i) = calc_power(grid_in, gene);
    end
    [B,I] = sort(power);
    best_routes = genes(I(1:GA_selection),:);

    genes = zeros(size(genes));
    genes(1,:) = best_routes(1,:); % save best route
    %% Mutations
    for i=2:GA_population
        goodRoute = true;
        while goodRoute
            route = [randi(N,1,max_len); randi(N,1,max_len)]';
            route(end,:) = route(1,:);
            goodRoute = ( calc_distance(route) > max_len*2 );
        end
        genes(i,:) = route(:);
    end
    
    %% Crossover
    
    x = best_routes(1,1:max_len);
    y = best_routes(1,max_len+1:end);
    plot([1, N],[1, N],'.', x, y);
    drawnow;
    
end

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

