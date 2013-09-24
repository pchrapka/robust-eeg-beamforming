function analysis_simulation_ex1_epsilon(cfg)
%ANALYSIS_SIMULATION_EX1_EPSILON analyzes data from ex1_epsilon
%   ANALYSIS_SIMULATION_EX1_EPSILON(CFG)
% 
%   Input
%   cfg.sim_name
%       source_name

scenario_name = 'ex1_epsilon';

%% Load the data
% FIXME Data file name should be explicit in the cfg
data_file = ['..' filesep 'output' filesep...
    cfg.sim_name '_' cfg.source_name '_' scenario_name '.mat'];
load(data_file);

%% Plot the data
figure;
plot_series(data);

% gridlines([0.7,0.7,0.7]);

%% Save the figure to a file
file_name = ['output' filesep scenario_name];
out_file_name = [file_name '.eps'];
saveas(gcf, out_file_name,'epsc2');
fixPSlinestyle(out_file_name);

out_file_name = [file_name '.png'];
saveas(gcf, out_file_name);

end