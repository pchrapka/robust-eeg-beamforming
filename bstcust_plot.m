function bstcust_plot(study_idx, snr, time, save_image)
%
%   study_idx   Brainstorm's study index
%   snr         string indicating snr of data set
%   time        time to display in s
%   save        (boolean) flag to save figures

if nargin < 2
    snr = '0';
    time = 0;
    save_image = false;
elseif nargin < 3
    time = 0;
    save_image = false;
elseif nargin < 4
    save_image = false;
end

% Default figure position
winPos = [200, 200, 400, 250];

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

% Find the corresponding data files based on snr
find_snr = cellfun(...
    @(x) ~isempty(findstr(x, ['snr_' num2str(snr)])),...
    {study.Data.FileName});

% Display the time series data
[h_fig(start_idx),~,~] = view_timeseries(...
    study.Data(find_snr).FileName);
if time > 0
    panel_time('SetCurrentTime', time);
end
% Save & close the image
if save_image
    set(h_fig(start_idx), 'Position', winPos);
    drawnow; % Flush queue
    bstcust_saveimg(h_fig(start_idx),...
        study.Data(find_snr).FileName, time)
    close(h_fig(start_idx));
    h_fig(start_idx) = 0;
end

% Find the corresponding result files based on snr
find_snr = cellfun(...
    @(x) ~isempty(findstr(x, ['snr_' num2str(snr)])),...
    {study.Result.DataFile});

% Get the result file names
relative_file_names = {study.Result(find_snr).FileName};
n_files = length(relative_file_names);

h_fig = [h_fig zeros(1,n_files)];
for i=1:n_files
    % Display the source results
    [h_fig(start_idx+i),~,~] = view_surface_data([], relative_file_names{i});
    if time > 0
        panel_time('SetCurrentTime', time);
    end

    % Save & close the image
    if save_image
        set(h_fig(i+start_idx), 'Position', winPos);
        drawnow; % Flush queue
        bstcust_saveimg(h_fig(i+start_idx),...
            relative_file_names{i}, time)
        close(h_fig(i+start_idx));
        h_fig(i+start_idx) = 0;
    end
end

% Save the current figure handles to a file
save(out_file,'h_fig');

end
