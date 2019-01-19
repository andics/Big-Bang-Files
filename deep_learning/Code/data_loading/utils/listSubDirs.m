function [dir_path] = listSubDirs(dir_path)
%A custom function for listing sub directories, which excludes . and ..

files = dir(dir_path);

if isempty(files)
   fprintf('%s does not exist \n', dir_path) 
   return;
end
    
subDirs = [files.isdir];
dir_path = files(subDirs);

dir_path=dir_path(~ismember({dir_path.name},{'.','..'}));

end

