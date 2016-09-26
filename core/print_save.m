function print_save(datafile)

[filepath,filename,fileext] = fileparts(datafile);
fprintf('Saving %s%s\n\tin%s\n',filename,fileext,filepath);

end