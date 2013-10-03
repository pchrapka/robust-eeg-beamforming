function analysis_plot_data(cfg)
%ANALYSIS_PLOT_DATA analyzes data from experiments
%   ANALYSIS_PLOT_DATA(CFG)
% 
%   Input
%   cfg.file_in
%       exp_name

%% Load the data
load(cfg.file_in);

%% Plot the data
figure;
plot_series(data);
title(strrep(cfg.file_in,'_',' '));

%% Save the figure to a file
[~,data_file_name,~,~] = fileparts(cfg.file_in);

if ~isequal(cfg.exp_name,'')
    file_name = ['output' filesep data_file_name '_' cfg.exp_name];
else 
    file_name = ['output' filesep data_file_name];
end
out_file_name = [file_name '.eps'];
saveas(gcf, out_file_name,'epsc2');
fixPSlinestyle(out_file_name);

out_file_name = [file_name '.png'];
saveas(gcf, out_file_name);

end