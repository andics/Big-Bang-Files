function [isInRegion] = isPointInRegion(region_mask, point)
%Check if a point lies in a binary mask defined by region_mask
%point - [y, x]
x = round(point(2));
y = round(point(1));

try
    point_value = region_mask(y, x);
    if point_value == 1
        isInRegion = true; 
    else
        isInRegion = false; 
    end
catch
   isInRegion = false; 
end

end

