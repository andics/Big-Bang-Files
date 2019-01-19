function [isCircular, center, radius] = checkCircularity(BW)
%Filter small particles in the detected suture region by using the nature
%of their circular shape
%Input - binary mask
%Output - binary mask with no small 'blobs'
critical_ratio = 0.6;

[y, x] = find(BW);  % x and y are column vectors.
%[center, radius, ~] = minboundcircle(x,y);

xy = horzcat(x(:), y(:));
[radius, center, ~] = ExactMinBoundCircle(xy);

blob_area = bwarea(BW);
circle_area = pi*(radius^2);
area_ratio = blob_area/circle_area;

if area_ratio >= critical_ratio
isCircular = 1;
else
isCircular = 0; 
end

end
