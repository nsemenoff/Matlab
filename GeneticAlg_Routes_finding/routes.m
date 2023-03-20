clear all
clf

N=20; % 10x10 (NxN)
max_len = 10; % route len

for i=1:N
    for j=1:N
        plot(i,j,'r*');
        hold on
    end
end


fld = zeros(N,N);
old_power = 10000000;
legend_text = [];
for i=18:1:80
    max_len = i;
    
    route = zeros(max_len, 2);
    for j=1:max_len+1
        x = round( N/2 + 1/2 + 0.8*max_len/2/pi*cos(2*pi*(j-1)/max_len + pi/4) );
        y = round( N/2 + 1/2 + 0.8*max_len/2/pi*sin(2*pi*(j-1)/max_len + pi/4) );
        route(j,:) = [x, y];
    end

    route = check_route(route);
    
    power = calc_power(fld, route);
    route2 = route;
    for k=1:100
        for l=2:size(route,1)-1
            route2 = route;
            for x1=-1:1
                for y1=-1:1
                    route2(l,1) = route2(l,1) + x1;
                    route2(l,2) = route2(l,2) + y1;
                    
                    power2 = calc_power(fld,route2);
                    if (power2 < power) && (calc_distance(route2)<max_len*0.8)
                        route = route2;
                    end
                end
            end
        end
        route = check_route(route);
    end
    
    if old_power > calc_power(fld,route)
        old_power = calc_power(fld,route);
        clf

        xx = route(:,1);
        yy = route(:,2);
        plot(xx,yy,'LineWidth',2);
        hold on
%        axis([0.5 10.5 0.5 10.5])
        legend_text = [num2str(max_len*1000/3600, 'Период опроса %7.4f часов'), 'затраты энергии ', num2str(old_power/1.1, '%7.4f кДж')];
        title(legend_text);

        for i=1:N
            for j=1:N
                plot(i,j,'r*');
%                hold on
            end
        end
        disp([num2str(max_len,'%02d') ', ' num2str(calc_distance(route),'%05.2f, ') ' ' num2str(calc_power(fld, route))])
    end
    
end

