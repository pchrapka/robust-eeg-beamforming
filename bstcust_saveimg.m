function bstcust_saveimg(h_fig, relative_file_name, time)
% Saves a Brainstorm snapshot
%   h_fig   Brainstorm figure handle
%   relative_file_name  Brainstorm's relative data file name
%   time    Time to display

% Get the dir of the results file
output_dir = bst_fileparts(...
    file_fullpath(relative_file_name));
% Get figure name
name = get(gcf, 'Name');
name = [file_standardize(name) '_' num2str(time*1000) 'ms.png'];
img_file_name = fullfile(output_dir, name);
% Get the image
img = out_figure_image(h_fig);
% Save the image
imwrite(img, img_file_name);

end