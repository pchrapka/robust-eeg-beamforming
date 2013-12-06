function bstcust_plot(study_idx, time, save_image)
%
%   study_idx   Brainstorm's study index
%   time        time to display in s
%   save        (boolean) flag to save figures

if nargin < 2
    time = 0;
    save_image = false;
elseif nargin < 3
    save_image = false;
end

% Get the study data
study = bst_get('Study', study_idx);

% Load current fig handles
out_file = fullfile('output','bst_current_figs.mat');
if exist(out_file,'file')
    data = load(out_file);
    h_fig = data.h_fig;
    start_idx = length(h_fig) + 1;
else
    start_idx = 1;
    h_fig = zeros(1,1);
end

% Display the time series data
[h_fig(start_idx),~,~] = view_timeseries(study.Data.FileName);
if time > 0
    panel_time('SetCurrentTime', time);
end
% Save & close the image
if save_image
    bstcust_saveimg(h_fig(start_idx),...
        study.Data.FileName, time)
    close(h_fig(start_idx));
    h_fig(start_idx) = 0;
end

% Get the result file names
relative_file_names = {study.Result.FileName};
n_files = length(relative_file_names);

h_fig = [h_fig zeros(1,n_files)];
for i=1:n_files
    % Display the source results
    [h_fig(start_idx+i),~,~] = view_surface_data([], relative_file_names{i});

    % Save & close the image
    if save_image
        bstcust_saveimg(h_fig(i+start_idx),...
            relative_file_names{i}, time)
        close(h_fig(i+start_idx));
        h_fig(i+start_idx) = 0;
    end
end

% Save the current figure handles to a file
save(out_file,'h_fig');

end
