function [binary_input] = smoothEdge(binary_input)
%Smooth the edge of segmented bone

%{
E = edge(I,'canny');
%Dilate the edges
Ed = imdilate(E,strel('disk',10));
%Filtered image
Ifilt = imfilter(I,fspecial('gaussian'));
%Use Ed as logical index into I to and replace with Ifilt
I(Ed) = Ifilt(Ed);
%}

windowSize = 15;
kernel = ones(windowSize) * 2 / windowSize ^ 2;
blurryImage = conv2(single(binary_input), kernel, 'same');
binary_input = blurryImage > 0.5;

end

