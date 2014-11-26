function colors = solarizedColors(nColors)

% this function returns a n nColors x 3 array of color rgb values. If
% nColors is > than 8, color values are interpolated from these listed
% below

% these colors are from: http://ethanschoonover.com/solarized

baseColors = [
    220  50  47
    203  75  22
    181 137   0
    133 153  0
    42 161 152
    38 139 210
    108 113 196
    211  54 130]./255;

x = linspace(0,1,length(baseColors)); 

xi = linspace(0,1,nColors);

for c = 1:3 % r, g, b columns
    colors(:,c) = interp1(x,baseColors(:,c),xi);
end

colors = abs(colors); % in case there's a negative value