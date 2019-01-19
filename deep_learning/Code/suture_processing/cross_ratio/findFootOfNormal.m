function [coordinates] = findFootOfNormal(pt1, pt2, pt3)
%Find the coordinates of the foot of the normal from pt3 to the pt1-pt2
%line
x1 = pt1(2);
y1 = pt1(1);

x2 = pt2(2);
y2 = pt2(1);

x3 = pt3(2);
y3 = pt3(1);

k = ((y2-y1) * (x3-x1) - (x2-x1) * (y3-y1)) / ((y2-y1)^2 + (x2-x1)^2);
x4 = x3 - k * (y2-y1);
y4 = y3 + k * (x2-x1);

coordinates = [y4,x4];

end

