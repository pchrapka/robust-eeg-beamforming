%% analysis_simluation_ex1_epsilon.m
% Analyzes data from simulation_ex1_epsilon.m

clear all;
clc;

%% Load the data
data_file = ['output' filesep 'simulation_ex1_epsilon.mat'];
load(data_file);

%% Plot the data
figure;
plot_series(out);

% gridlines([0.7,0.7,0.7]);

%% Save the figure to a file
file_name = ['output' filesep 'ex1_epsilon'];
out_file_name = [file_name '.eps'];
saveas(gcf, out_file_name,'epsc2');
fixPSlinestyle(out_file_name);