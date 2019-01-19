function [output_mask] = threshholdFilter(image, org_mask, cluster_mask, show_text, method)
%Add an extra threshhold filtering ot detect sutures
if nargin < 5
%Hard threshholding
    
if show_text
  fprintf('Filtering image using hard threshholding... \n');
end
    
threshhold_value = findThreshhold(org_mask);

output_mask = (image <= threshhold_value);
output_mask(org_mask == 0) = 0;

output_mask(cluster_mask == 1) = 1;
output_mask = uint8(output_mask);

%{
else if strcmp(method, 'Otsu')
fprintf('Filtering image using Otsu''s threshholding... \n');
%}

        
end

end

