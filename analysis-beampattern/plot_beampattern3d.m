function plot_beampattern3d(cfg)
%PLOT_BEAMPATTERN3D plots beampattern data on cortex
%   PLOT_BEAMPATTERN3D plots beampattern data on the cortex
%
%   cfg.files
%       (cell array) filenames of beampattern data
%   cfg.head        
%       head model cfg (see hm_get_data);
%
%   See also COMPUTE_BEAMPATTERN

% Load the head model
data_in = hm_get_data(cfg.head);
head = data_in.head;
clear data_in;

% Load the tesselated data
bstdir = brainstorm.bstcust_getdir('db');
fprintf('Loading surface file:\n\t%s\n', head.SurfaceFile);
tess = load(fullfile(bstdir,...
    'Protocol-Phil-BEM','anat',head.SurfaceFile));

% Get number of data sets
n_plots = length(cfg.files);

for i=1:n_plots
    % Load the data
    din = load(cfg.files{i});
    beampattern_data = din.data.beampattern;
    
    % Plot the 3D beampattern
    % FIXME Move out of brainstorm package
    brainstorm.bstcust_plot_surface3d_data(tess, beampattern_data);
    
    figname = strrep(din.data.name, '_', ' ');
    set(gcf,'name',figname);%,'numbertitle','off')
end

end