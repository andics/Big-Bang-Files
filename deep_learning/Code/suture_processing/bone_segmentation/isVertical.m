function [is_vertical, angle] = isVertical(imageFile)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

angle = regionprops(imageFile, 'Orientation');
angle = angle(1).Orientation;

if abs(angle)>45
    is_vertical = true;
else
    is_vertical = false;
        
end
    
end

