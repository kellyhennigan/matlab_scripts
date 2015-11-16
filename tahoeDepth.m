
% if we were to hold a string from the west shore to the east shore, 
% we want to know how far below the earth's surface the string would be at
% the midpoint
%
%%

C = 24901; % circumference of the earth in miles 
tahoeDiameter = 11; % miles (west shore to east shore)
ftPerMile = 5280;

r = C/(2*pi); % earth's radius


theta = ((tahoeDiameter/2)/C)*360;

a = r*cosd(theta)

b = r*sind(theta);

d = r-a

tahoeFtDepth = d*ftPerMile