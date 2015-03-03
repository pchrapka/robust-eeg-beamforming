%% Options
% highres_model = 'head_Colin27_bem_vol_30000V.mat';
highres_model = 'head_Colin27_bem_surf_15000V.mat';
manual = false; % option to manually select the ROI

%% Load data
% Load head model used for simulation
cfg = [];
cfg.type = 'brainstorm';
cfg.file = 'head_Default1_bem_500V.mat';
din = hm_get_data(cfg);
head_orig = din.head;

% Load source vertex
cfg = [];
cfg.head = head_orig;
cfg.type = 'index';
cfg.idx = 295;
[vert_idx, vert_source] = hm_get_vertices(cfg);

% Load high res head model
cfg = [];
cfg.type = 'brainstorm';
cfg.file = highres_model;
din = hm_get_data(cfg);
head_highres = din.head;

%% Plot grid points
figure;
plot_brainstorm_grid(head_highres,10,'black','o','filled');
axis equal
title('Full High Resolution');

%% Select brain section containing source
% Select source grid within a certain distance along x direction
marginy = 0.005; % in m
marginz = 0.04;
layers = 17;

% Select grid points along the x direction (front to back)
% selx = select_points(head_highres.GridLoc(:,1), vert_source(1), margin);
sely = select_points(head_highres.GridLoc(:,2), vert_source(2), marginy);
selz = select_points(head_highres.GridLoc(:,3), vert_source(3), marginz);

sel = sely & selz;

head_line = head_highres;
head_line.GridLoc = head_highres.GridLoc(sel,:);

% Plot selected points superimposed
hold on;
plot_brainstorm_grid(head_line,20,'red','o','filled');
axis equal

hold on;
scatter3(vert_source(1),vert_source(2),vert_source(3),...
    40,'blue','o','filled');

% H = aet_source_get_gain(cfg.loc, cfg.head_model);

%% Plot line grid points alone
figure;
plot_brainstorm_grid(head_line,20,'red','o','filled');
title('Line High Resolution');
axis equal

hold on;
scatter3(vert_source(1),vert_source(2),vert_source(3),...
    40,'blue','o','filled');

%% Refine points using radial selection criteria

% figure;
% x = head_line.GridLoc(:,1);
% z = head_line.GridLoc(:,3);
% r=.09;
% disp('alpha shaping in progress...');
% p=ashape(x,z,r,'-bc');
% disp('alpha shaping done');
% disp(sprintf('runtime%10.3fs',p.runtime));
% % ... keep for later use
% po=p;

%% Refine points manually with an ROI

% ROI file name
projectdir = 'analysis-beampattern-highres';
outfile = fullfile(projectdir,...
    'roi_beampattern_temp.mat');

if manual
    % Ask user if they want to specify a new ROI
    prompt = 'New ROI (1) or load ROI (2)?';
    response = input(prompt, 's');
    switch(response)
        case '1'
            figure;
            X = [head_line.GridLoc(:,1), head_line.GridLoc(:,3)];
            scatter(X, 20,'red','o','filled');
            hold on;
            scatter(vert_source(1),vert_source(3),...
                40,'blue','o','filled');
            axis equal
            % Select roi
            roi = impoly();
            % Save roi
            save(outfile, 'roi');
        case '2'
            % Ask which roi
            options = dir([projectdir filesep '*.mat']);
            for i=1:length(options)
                fprintf('%d: %s\n', i, options(i).name)
            end
            prompt = 'Choose a file:';
            response = input(prompt, 's');
            % Load roi
            infile = fullfile(projectdir, options(str2num(response)).name);
            din = load(infile);
            roi = din.roi;
        otherwise
            error('reb:exphighres',...
                'unknown option');
    end
else
    infile = fullfile(projectdir, 'roi_beampattern_rect.mat');
    din = load(infile);
    roi = din.roi;
end

nodes = getPosition(roi);
selected_indices = inpoly(X, nodes);

head_roi = head_line;
head_roi.GridLoc = head_line.GridLoc(selected_indices,:);

%% Plot line grid points alone
figure;
plot_brainstorm_grid(head_roi,20,'red','o','filled');
title('ROI High Resolution');
axis equal

hold on;
scatter3(vert_source(1),vert_source(2),vert_source(3),...
    40,'blue','o','filled');