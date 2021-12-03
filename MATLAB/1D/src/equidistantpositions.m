function [x] = equidistantpositions(divisions)

a = -1;
b = 1;

%% EQUIDISTANT IN ELEMENT DOMAIN:
% size = (b-a)/(divisions+1);
% 
% x = zeros(1,divisions);
% 
% for i = 1:divisions
%     x(i) = a + i*size;
% end

%% EQUIDISTANT IN FULL DOMAIN:

divisions = 2*divisions-1;

size = (b-a)/(divisions+1);

n = (divisions+1)/2;

x = zeros(1,n);

x(1) = a + size;

for i = 2:n-1
    x(i) = x(i-1) + 2*size;
end

x(n) = b - size;

end

