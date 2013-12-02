function brainstorm_plot(study_idx)

% Get the study data
study = bst_get('Study', study_idx);

% Display the time series data
[h_fig(1),~,~] = view_timeseries(study.Data.FileName);

% Get the result file names
relative_file_names = {study.Result.FileName};
n_files = length(relative_file_names);

h_fig = [h_fig zeros(1,n_files)];
for i=1:n_files
    [h_fig(1+i),~,~] = view_surface_data([], relative_file_names{i});
end

% Save the current figure handles to a file
save(fullfile('output','bst_current_figs.mat'),'h_fig');

end