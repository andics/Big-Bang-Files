function [index] = path2index(path_str)
%Return numberical index of the provided label

B = regexp(path_str,'\d*','Match');
for ii= 1:length(B)
  if ~isempty(B{ii})
      index(ii,1)=str2double(B{ii}(end));
  else
      index(ii,1)=NaN;
  end
end

end

