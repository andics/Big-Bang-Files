function [index_point] = findCrossLine_new(bone_segment, sutures_mask, angle, show)
%Find the points defining the compare line used to detect the depth covered
%by the suture
%output index - (2,2)
%y coordinates = index(:,2)
%x coordinates = index(:,1)
%bone_segment - binary mask of the bone segmentation
%angle - orientation of bone segment
line_vert = false;
debugging = false;

[binary_y, binary_x] = find(sutures_mask);

bone_mask_bound_img = edge(bone_segment,'Prewitt');
bone_mask_bound = bwboundaries(bone_mask_bound_img);

%Select the centroid of the suture binary mask
center_y = round(mean(binary_y));
center_x = round(mean(binary_x));

angle = -angle;
grad_bone = tand(angle);
grad_perp = -1/grad_bone;
if grad_perp == Inf || grad_perp == -Inf
    line_vert = true;
end

c = center_y - grad_perp*center_x;

line_equation = @(x) grad_perp * x + c;

%{
f = figure('visible','off');
plot(bone_segment);
perp_line = refline([grad_perp c]);
line_x = perp_line.('XData');
line_y = perp_line.('YData');
close(f);
%}
for x = center_x : -1 : 1
   y = line_equation(x);
   if isPointInRegion(bone_segment, [y, x])
     if debugging
      hold on;
      plot(x, y, 'o',...
        'MarkerFaceColor','red',...
        'MarkerSize',5);
      hold off;
     end
   else
       index_point(1,:) = [y, x];
       break;
   end
end
   
%Find the first point from the perp_line laying outside of the bone segment
%and use it as boundary for the more specific line generation afterwards
for x = center_x : 1 : size(sutures_mask, 1)
   y = line_equation(x);
   if isPointInRegion(bone_segment, [y, x])
     if debugging
      hold on;
      plot(x, y, 'o',...
        'MarkerFaceColor','red',...
        'MarkerSize',5);
      hold off;
     end
   else
       index_point(2,:) = [y, x];
       break;
   end
end
line_x = index_point(:,2);
line_y = index_point(:,1);

if line_vert
    line_y(1,1) = 1;
    line_y(2,1) = size(bone_segment, 1);
end

line_length = sqrt((line_x(1) - line_x(2))^2 + (line_y(1) - line_y(2))^2);
[x_data, y_data, ~] = improfile(bone_segment, line_x, line_y, line_length);
line_coordinates = horzcat(y_data, x_data);
%whos line_coordinates;
[y_data, x_data] = extractLineBoneCross(bone_segment, y_data, x_data);
index_point = zeros(2, 2);
index_point(1,:) = [y_data(1), x_data(1)];
index_point(2,:) = [y_data(end), x_data(end)];

if show
figure;
bone_mask_bound_img(sutures_mask == 1) = sutures_mask(sutures_mask == 1);
imshow(bone_mask_bound_img, []);
title('Points defining compare line');
hold on;
%Draw the centroid
plot(center_x, center_y, 'o',...
 'MarkerFaceColor', 'yellow',...
 'MarkerSize', 10);

plot(index_point(:,2), index_point(:,1), 'o',...
    'MarkerFaceColor','green',...
    'MarkerSize',15);
hold off;
end

end

