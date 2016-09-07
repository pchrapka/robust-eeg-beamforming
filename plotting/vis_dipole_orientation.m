% Get the head model
hmfactory = HeadModel();
hm = hmfactory.createHeadModel('brainstorm','head_Default1_3sphere_500V.mat');
hm.load();

% % NOTE requires the surface tesselation file
% % Plot surface file
% Hpatch1 = patch('Vertices',Vertices,'Faces',Faces,...
%     'EdgeColor',[.6 .6 .6],'FaceColor',[0.9 0.9 0.9]);

% Plot grid points
figure;
scatter3(...
    hm.data.GridLoc(:,1),...
    hm.data.GridLoc(:,2),...
    hm.data.GridLoc(:,3),...
    10,'black','o','filled');

origin = hm.get_origin();
% Plot origin
hold on
scatter3(...
    origin(1),origin(2),origin(3),...
    50,'red','o','filled');

% Find points within a radius to a point
pnt_idx = 400;%207; % Center
[distr_idx,~] = hm.get_vertices('type','radius','center_idx',pnt_idx,'radius',2/100);

disp(distr_idx);

% Plot vertices within radius
hold on;
% Remove the center first
idx = find(distr_idx == pnt_idx);
distr_idx_others = distr_idx;
distr_idx_others(idx) = [];
scatter3(...
    hm.data.GridLoc(distr_idx_others,1),...
    hm.data.GridLoc(distr_idx_others,2),...
    hm.data.GridLoc(distr_idx_others,3),...
    50,'blue','o','filled');
hold on;
scatter3(...
    hm.data.GridLoc(pnt_idx,1),...
    hm.data.GridLoc(pnt_idx,2),...
    hm.data.GridLoc(pnt_idx,3),...
    50,'red','o','filled');

% Get the dipole orientation, normal to the cortex surface
cfg = [];
cfg.head = hm.data;
cfg.idx = distr_idx;
distr_mom = aet_sim_dipole_orientation(cfg);

% Plot moment vectors
scaling = 2;
starts = hm.data.GridLoc(distr_idx,:);
ends = starts + scaling*distr_mom;
hold on;
quiver3(...
    starts(:,1),starts(:,2),starts(:,3),...
    ends(:,1),ends(:,2),ends(:,3));


