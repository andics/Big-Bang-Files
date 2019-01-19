function [clustered_pixels] = clusterColorsCMeans(inputImage, suture_mask, nColors, show)
%cluster image regions and segment the suture

nrows = size(inputImage, 1);
ncols = size(inputImage, 2);

%Z axis
inputData = double(inputImage(suture_mask == 1));

partition_exponent = [10]; %2.0 3.0 4.0];
n = numel(partition_exponent);

for i = 1:n
    % Cluster the data.
    options = [partition_exponent(i) NaN NaN 0];
    [centers,U] = fcm(inputData, nColors, options);
    
    % Classify the data points.
    maxU = max(U);
    index1 = find(U(1,:) == maxU);
    index2 = find(U(2,:) == maxU);
    
    clustered_pixels = zeros(size(inputData, 1), 1);
    clustered_pixels(index1) = 1;
    clustered_pixels(index2) = 2;
    inputImage(suture_mask == 1) = clustered_pixels(:);
    clustered_pixels = inputImage;
    clustered_pixels = reshape(clustered_pixels,nrows,ncols);
    
    if show
    % Find data points with lower maximum membership values.
    index3 = find(maxU < 0.5);
    % Calculate the average maximum membership value.
    averageMax = mean(maxU);
    % Plot the results.
    
    figure;
    subplot(1,2,i+1);
    plot(inputData(index1,1), 'ob')
    hold on
    plot(inputData(index2,1), 'or')
    plot(inputData(index3,1), 'xk', 'LineWidth',2)
    plot(centers(1,1), 'xb', 'MarkerSize', 15, 'LineWidth', 3)
    plot(centers(2,1), 'xr', 'MarkerSize', 15, 'LineWidth', 3)
 %  hold off
    title(['Partition exp = ' num2str(partition_exponent(i)) ', Ave. Max. = ' num2str(averageMax,3)])
    subplot(1,2,i);
    imshow(clustered_pixels, []);title('Segmentated result');
    hold off
    end
end

end

