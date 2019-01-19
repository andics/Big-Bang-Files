function [new_cat_mask] = filterPrediction(cat_mask, allScores, show_text)
%Filter prediction of pixels with probability less than a certain
%threshold
%If a big probability threshhold produces a very small region, reduce the
%probability threshold
area_threshold_small_regions = 451;
threshold_big_regions = 0.85;
threshold_small_regions = 0.6;

new_cat_mask = cat_mask;
new_cat_mask(allScores(:,:,1) < threshold_big_regions) = categorical(cellstr('background'));

suture_binary_mask_area = numel(find(catToBinary(new_cat_mask) == 1));

if suture_binary_mask_area < area_threshold_small_regions
    if show_text
    fprintf('Size of found region is small. Using a smaller neural net threshold! \n')
    end
    new_cat_mask = cat_mask;
    new_cat_mask(allScores(:,:,1) < threshold_small_regions) = categorical(cellstr('background'));
end

end

