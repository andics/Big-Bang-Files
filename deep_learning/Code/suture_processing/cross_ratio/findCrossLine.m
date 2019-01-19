function [index_point] = findCrossLine(bone_segment, sutures_mask, show)
%Find the points defining the compare line used to detect the depth covered
%by the suture
%output index - (2,2)
%y coordinates = index(:,2)
%x coordinates = index(:,1)

bone_mask_bound_img = edge(bone_segment,'Prewitt');
bone_mask_bound = bwboundaries(bone_mask_bound_img);

%Extract the two largest boundary objects
%Assuming those to be the bone boudaries
bone_mask_bound_sizes = cell2mat(cellfun(@(S) numel(S), bone_mask_bound, 'uni', false));
[size_values, size_indices] = sort(bone_mask_bound_sizes, 'descend');
%largest_values = size_values(1:2);
index_of_largest_values = size_indices(1:2);
bone_mask_bound = bone_mask_bound(index_of_largest_values);

%Select a random point from the suture regions
ind = find(sutures_mask); % linear indices of nonzero values
ind_selected = ind(round(length(ind) / 2)); % randomly select one, in linear index...
[ref_y ref_x] = ind2sub(size(sutures_mask), ind_selected); % convert to x y coordinates

index_point = zeros(numel(bone_mask_bound),2);

current_boundary = bone_mask_bound{1};
overall_min_dist = Inf;
for j=1:size(current_boundary,1)
   current_cord_y = current_boundary(j, 1);
   current_cord_x = current_boundary(j, 2);
   current_distance = sqrt( (current_cord_y - ref_y)^2 + (current_cord_x - ref_x)^2 );
    if current_distance < overall_min_dist
      overall_min_dist = current_distance;
      index_point(1,:) = current_boundary(j,:);
    end
end
   
%Find the closest point on edge 2 to the point on edge 1 
current_boundary = bone_mask_bound{2};
overall_min_dist = Inf;
for j=1:size(current_boundary,1)
   current_cord_y = current_boundary(j, 1);
   current_cord_x = current_boundary(j, 2);
   current_distance = sqrt( (current_cord_y - index_point(1,1))^2 + (current_cord_x - index_point(1,2))^2 );
    if current_distance < overall_min_dist
      overall_min_dist = current_distance;
      index_point(2,:) = current_boundary(j,:);
    end
end
   
bone_mask_bound_img(sutures_mask == 1) = sutures_mask(sutures_mask == 1);

if show
figure;
imshow(bone_mask_bound_img, []);
title('Points defining compare line');


hold on;
plot(index_point(:,2), index_point(:,1), 'o',...
    'MarkerFaceColor','green',...
    'MarkerSize',15);
hold off;
end

end

