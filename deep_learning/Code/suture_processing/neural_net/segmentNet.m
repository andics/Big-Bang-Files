function [I, C, scores, allScores] = segmentNet(sutNet, imds, index, show)
%Segment an image using a semnatic segmentation neural network

I = readimage(imds, index);

[C, scores, allScores] = semanticseg(I, sutNet);
I = I(:,:,1);

if show

B = labeloverlay(I, C, 'Colormap', 'gray', 'Transparency', 0.6);

figure;
imshow(B);
title('Classified suture region with no certainty filtering')

end

end

