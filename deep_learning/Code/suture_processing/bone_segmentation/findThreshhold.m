function [threshhold_value] = findThreshhold(suture_mask)
%find a threshhold value for the suture based on it's area
threshhold_area = 0.0061;

suture_mask_area = regionprops(suture_mask, 'Area');
suture_mask_area = suture_mask_area.('Area');

if numel(suture_mask) * threshhold_area >= suture_mask_area
    threshhold_value = 210;
else
    threshhold_value = 185;
end

end

