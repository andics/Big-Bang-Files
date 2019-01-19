function [] = gTruth_check_RGB(gTruth)
%Ensure all images in the provided gtround truth file consist of three
%color channels
%Modify and save new images in three color channel format, where needed

[imds,~] = pixelLabelTrainingData(gTruth);
    
%Ensure all images are in RGB format
%checkDataRGB(imds);
[~] = checkDataRGB(imds);

end

