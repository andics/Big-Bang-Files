function [imageFile] = loadURLImage(imageURL)
%Attempt to load an image from a URL
%If there is a connection issue, wait and try again several times
%P.S. Loving school internet... 
numOfTrials = 3;
trialInterval = 10; %Time in seconds

imageFile = [];

    for i=1:numOfTrials
       if isempty(imageFile)
        try
           imageFile = imread(imageURL);
       catch 
           fprintf('Error occured while downloading image. Waiting to make another attempt... \n');
           pause(trialInterval);
        end
       
       else
        break;
       end
    end

end

