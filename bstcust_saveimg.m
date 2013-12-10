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
name = [file_standardize(name) '_' num2str(time*1000) 'ms'];
img_file_name = fullfile(output_dir, name);

% Save image as a png
% Get the image
% img = out_figure_image(h_fig);
% Focus on figure (captures the contents the topmost figure)
pause(.01);
drawnow;
figure(h_fig);
drawnow;
frameGfx = getscreen(h_fig);
img = frameGfx.cdata;
% Save the image
imwrite(img, [img_file_name '.png']);

% Save image as eps
% set(gcf,'PaperPositionMode','auto')
% saveas(h_fig, [img_file_name '.eps'],'epsc2');

% % img = imread('peppers.png');
% imshow(img,'Border','tight',...
%        'InitialMagnification',100);
% print([img_file_name '.eps'],'-deps');
% print([img_file_name '.eps'],'-depsc2','-r300');

end