function [clustered_pixels] = clusterFeaturesCMeans(inputImage, suture_mask, nColors, show)
%cluster image regions and segment the suture

se=1; % the parameter of structuing element used for morphological reconstruction
w_size=3; % the size of fitlering window

nrows = size(inputImage, 1);
ncols = size(inputImage, 2);

%Z axis
inputData = double(inputImage(suture_mask == 1));
[coordinatesY, coordinatesX]= find(suture_mask == 1);
inputData = horzcat(coordinatesX, coordinatesY, inputData);

%{
[center1, U1 , ~, ~]=FRFCM(double(inputData), nColors, se, w_size);
clustered_pixels=fcm_image(inputData,U1,center1);
whos U1;
Time1=toc;
disp(strcat('running time is: ',num2str(Time1)));
%}

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
    plot3(inputData(index1,1), inputData(index1,2), inputData(index1,3), 'ob')
    hold on
    plot3(inputData(index2,1), inputData(index2,2), inputData(index2,3), 'or')
    plot3(inputData(index3,1), inputData(index3,2), inputData(index3,3), 'xk', 'LineWidth',2)
    plot3(centers(1,1), centers(1,2), centers(1,3), 'xb', 'MarkerSize', 15, 'LineWidth', 3)
    plot3(centers(2,1), centers(2,2), centers(2,3), 'xr', 'MarkerSize', 15, 'LineWidth', 3)
    title(['Partition exp = ' num2str(partition_exponent(i)) ', Ave. Max. = ' num2str(averageMax,3)])
    axis ij
    axis tight
    grid on;
    daspect([1,1,1])
    rotate3d on;
    colormap('gray');
    subplot(1,2,i);
    imshow(clustered_pixels, []);title('Segmentated result');
    hold off
    end
end

end

