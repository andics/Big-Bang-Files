function [cross_ratio] = calculateCrossRatio(pt1, pt2, suture_binary_mask, show, show_text)
%Calcualte the ratio between the depth of the bone and the cross section
%cross lenght of the suture

[y_suture_mask_cords, x_suture_mask_cords] = find(suture_binary_mask);
suture_mask_coordinates = horzcat(y_suture_mask_cords,x_suture_mask_cords);

foot_coordinates = zeros(size(suture_mask_coordinates, 1), 2);

for i=1:size(suture_mask_coordinates, 1)
    pt3 = suture_mask_coordinates(i,:);
    foot_coordinates(i,:) = findFootOfNormal(pt1, pt2, pt3);
end

foot_coordinates_rounded = unique(round(foot_coordinates), 'rows');

line_length = sqrt((pt1(1) - pt2(1))^2 + (pt1(2) - pt2(2))^2);
[cx , cy, ~] = improfile(suture_binary_mask, [pt1(2), pt2(2)], [pt1(1), pt2(1)], line_length);
line_coordinates = horzcat(cy, cx);
line_coordinates_rounded = unique(round(line_coordinates), 'rows');

values_in_common = intersect(foot_coordinates_rounded, line_coordinates_rounded, 'rows');
num_of_values_in_common = size(values_in_common, 1);

cross_ratio = num_of_values_in_common / size(line_coordinates_rounded, 1);

if show
hold on;
plot(foot_coordinates(:,2), foot_coordinates(:,1), 'r*', 'MarkerSize', 7);
hold off;
end

if show_text
fprintf('Cross ratio: %f \n \n', cross_ratio)
end

end

