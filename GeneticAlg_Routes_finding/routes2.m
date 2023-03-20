clear all
close all

N=10; % 10x10 (NxN)
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
for i=20:1:30
    max_len = i;
    old_power = 10000000;
    
    for test=1:50
        route = zeros(max_len, 2);
        x_phase = 0; %randi(4)*pi/4; %rand(1)*pi;
        k_x = rand(1)/2 + 0.5;
        k_y = rand(1)/2 + 0.5;
        type = rand(1);
        for j=1:max_len+1
            if (type > 0.5) || (max_len<20)
                x = round( N/2 + 1/2 + k_x*max_len/2/pi*cos(2*pi*(j-1)/max_len + x_phase) );
                y = round( N/2 + 1/2 + k_y*max_len/2/pi*sin(2*pi*(j-1)/max_len + x_phase) );
            else
                x = round( N/2 + 1/2 + k_x*max_len/2/pi*sin(2*pi*(j-1)/max_len + x_phase) );
                if abs(j-max_len/2)<0.1*max_len
                    y = round( N/2 + 1/2 + k_y*max_len/2/pi*(1.5*sin(2*pi*(j-1)/(max_len/2) + x_phase)).*sign(sin(2*pi*(j-1)/max_len + x_phase)) );
                else
                    y = round( N/2 + 1/2 + k_y*max_len/2/pi*sin(2*pi*(j-1)/(max_len/2) + x_phase).*sign(sin(2*pi*(j-1)/max_len + x_phase)) );
                end
                    
            end
            route(j,:) = [x, y];
%            route(j,:) = [x, y];
        end
        route(max_len+1,:) = route(1,:);
%        if rand(1)>0.5
%            route(1,:) = [N/2 N/2];
%            route(end,:) = [N/2 N/2];
%        end

%        route = check_route(route);

        power = calc_power(fld, route);
        route2 = route;
        for k=1:100
            for l=2:size(route,1)-1
                route2 = route;
                for x1=-2:2
                    for y1=-2:2
                        route2(l,1) = route2(l,1) + x1;
                        route2(l,2) = route2(l,2) + y1;

                        power2 = calc_power(fld,route2);
                        if (power2 < power) && (calc_distance(route2)<max_len*0.8)
                            route = route2;
                        end
                    end
                end
            end
%            route = check_route(route);
        end

        if old_power > calc_power(fld,route)
            old_power = calc_power(fld,route);
            fig1 = figure;
            clf

            xx = route(:,1);
            yy = route(:,2);
            plot(xx,yy,'LineWidth',2);
            hold on
    %        axis([0.5 10.5 0.5 10.5])
            legend_text = [num2str(calc_distance(route)*1000/3600, 'Период опроса %7.4f часов'), ', затраты энергии ', num2str(old_power/1.1, '%7.4f кДж')];
            title(legend_text);

            for i=1:N
                for j=1:N
                    plot(i,j,'r*');
    %                hold on
                end
            end
            drawnow;
            
            img_name = ['Result_' num2str(max_len) '_' num2str(test) '.jpg'];
            disp(img_name)
            saveas(fig1, img_name);
            
            pwr = calc_power(fld, route);
            disp([num2str(max_len,'%02d') ', ' num2str(calc_distance(route),'%05.2f, ') ' ' num2str(pwr)])
        end
    end
end

