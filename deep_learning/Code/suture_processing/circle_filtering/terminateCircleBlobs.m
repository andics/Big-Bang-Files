function [L] = terminateCircleBlobs(BW, show)
%Filter diploe particles in the detected suture region by using the nature
%of their circular shape
%Input - binary mask
%Output - binary mask with no circle 'blobs'

if show
figure;
imshow(BW, []);
title('Filtering of circlular (diploe) particles');
end

[L, num] = bwlabel(BW, 8);
for k = 1 : num
    thisBlob = ismember(L, k);
    [isCircular, center, radius] = checkCircularity(thisBlob);
    if isCircular
        L(L==k) = 0;
    else
        L(L==k) = 1;
    end
    
    if show
    hold on;
    plot(thisBlob);
    viscircles(center,radius);
    hold off;
    end
end

end

