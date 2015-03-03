%% Options
% highres_model = 'head_Colin27_bem_vol_30000V.mat';
highres_model = 'head_Colin27_bem_surf_15000V.mat';
manual = false; % option to manually select the ROI

idx = select_beampattern_roi(highres_model, manual);

% Check selected indices
cfg = [];
cfg.type = 'brainstorm';
cfg.file = highres_model;
din = hm_get_data(cfg);
head_highres = din.head;

head_roi = head_highres;
head_roi.GridLoc = head_highres.GridLoc(idx,:);

figure;
plot_brainstorm_grid(head_roi,20,'red','o','filled');
title('ROI High Resolution');
axis equal