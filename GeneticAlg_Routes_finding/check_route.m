function res = check_route(route)
res = route;

i=2;
while i<size(res,1)-1
    if (res(i,1)==res(i-1,1)) && (res(i,2)==res(i-1,2))
        res = [res(1:i-1,:); res(i+1,:)];
    end
    i = i + 1;
end
