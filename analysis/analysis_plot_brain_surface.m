function analysis_plot_brain_surface(cfg)

% Load the file
% The format will be a parameter sweep
load(cfg.file_in)

% Select the data for plotting
% Iteration
out_temp = out([out.iteration] == cfg.iteration);
% SNR
out_temp = out_temp([out.snr] == cfg.snr);
% Epsilon, if it's there
if isfield(out_temp(1), 'epsilon')
    out_temp = out_temp(...
        cellfun(@(x)isequal(x, cfg.epsilon(1,:)'),...
        {out_temp.epsilon}));
end

% Make sure the number of vertices matches in the head model the length of
% the data array
n_vertices = size(cfg.head_model.GridLoc,1);
if n_vertices ~= length(out_temp)
    warning('reb:analysis_plot_brain_surface',...
        'Dealbreaker');
end

end