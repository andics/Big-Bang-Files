function [suture_binary_mask] = catToBinary(cat_mask)
%Transform a categorical from the neural network to a binary mask

suture_binary_mask = cat_mask;
suture_binary_mask(suture_binary_mask=='suture') = '1';
suture_binary_mask(suture_binary_mask=='background') = '0';
suture_binary_mask = logical(double(string(suture_binary_mask)));

end

