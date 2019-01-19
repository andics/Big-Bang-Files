function [new_binary] = seperateBlobs(suture_mask)
%Seperate particles with weak connections

D = -bwdist(~suture_mask);

mask = imextendedmin(D,1);
D2 = imimposemin(D,mask);
Ld2 = watershed(D2);
new_binary = suture_mask;
new_binary(Ld2 == 0) = 0;

end

