% Get the head model
cfg = [];
cfg.type = 'brainstorm';
cfg.file = 'head_Default1_3sphere_500V.mat';
data = hm_get_data(cfg);
head = data.head;

% % NOTE requires the surface tesselation file
% % Plot surface file
% Hpatch1 = patch('Vertices',Vertices,'Faces',Faces,...
%     'EdgeColor',[.6 .6 .6],'FaceColor',[0.9 0.9 0.9]);

% Plot grid points
figure;
scatter3(...
    head.GridLoc(:,1),...
    head.GridLoc(:,2),...
    head.GridLoc(:,3),...
    10,'black','o','filled');

origin = hm_get_origin(head);
% Plot origin
hold on
scatter3(...
    origin(1),origin(2),origin(3),...
    50,'red','o','filled');

% Find points within a radius to a point
pnt_idx = 207; % Center

cfg = [];
cfg.head = head;
cfg.type = 'radius';
cfg.center_idx = pnt_idx;
cfg.radius = 2/100;
[distr_idx,~] = hm_get_vertices(cfg);

disp(distr_idx);

% Plot vertices within radius
hold on;
% Remove the center first
idx = find(distr_idx == pnt_idx);
distr_idx_others = distr_idx;
distr_idx_others(8) = [];
scatter3(...
    head.GridLoc(distr_idx_others,1),...
    head.GridLoc(distr_idx_others,2),...
    head.GridLoc(distr_idx_others,3),...
    50,'blue','o','filled');
hold on;
scatter3(...
    head.GridLoc(pnt_idx,1),...
    head.GridLoc(pnt_idx,2),...
    head.GridLoc(pnt_idx,3),...
    50,'red','o','filled');

% Get the dipole orientation, normal to the cortex surface
cfg = [];
cfg.head = head;
cfg.idx = distr_idx;
distr_mom = dipole_orientation(cfg);

% Plot moment vectors
scaling = 2;
starts = head.GridLoc(distr_idx,:);
ends = starts + scaling*distr_mom;
hold on;
quiver3(...
    starts(:,1),starts(:,2),starts(:,3),...
    ends(:,1),ends(:,2),ends(:,3));


