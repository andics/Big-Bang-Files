function [y_data_new, x_data_new] = extractLineBoneCross(bone_segment, y_data, x_data)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
y_data_new = y_data;
x_data_new = x_data;

for i=1:numel(y_data)
    current_y = y_data(i);
    current_x = x_data(i);
    current_point = [current_y, current_x];
    if isPointInRegion(bone_segment, current_point) == false
        y_data_new(i) = NaN;
        x_data_new(i) = NaN;
    end
end

y_data_new = y_data_new(~isnan(y_data_new));
x_data_new = x_data_new(~isnan(x_data_new));

end

