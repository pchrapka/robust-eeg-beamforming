% Script to match a vertex in different head models
headfile_source = 'head_Default1_bem_500V.mat';
headfile_dest = 'head_Default1_bem_15028V.mat';

% index_source = 295;
index_source = 400;

%% Load head models
% Load source head model
cfg = [];
cfg.type = 'brainstorm';
cfg.file = headfile_source;
din = hm_get_data(cfg);
head_source = din.head;

% Load destination head model
cfg = [];
cfg.type = 'brainstorm';
cfg.file = headfile_dest;
din = hm_get_data(cfg);
head_dest = din.head;

%% Get source vertex
cfg = [];
cfg.head = head_source;
cfg.type = 'index';
cfg.idx = index_source;
[vert_idx, vert_source] = hm_get_vertices(cfg);

%% Find matching vertex in destination head model
ncomp = length(vert_source);
nvert = size(head_dest.GridLoc,1);

sel = ones(nvert, 1);
for i=1:ncomp
    sel = sel & (head_dest.GridLoc(:,i) == vert_source(i));
end

index_dest = find(sel > 0);
if isempty(index_dest)
    error('reb:match_vertex',...
        'no matching vertex');
end

%% Get dest vertex
cfg = [];
cfg.head = head_dest;
cfg.type = 'index';
cfg.idx = index_dest;
[vert_idx, vert_dest] = hm_get_vertices(cfg);

%% Print results
fprintf('old\n\tindex: %d\n\tvertex: %f %f %f\n', index_source, vert_source);
fprintf('new\n\tindex: %d\n\tvertex: %f %f %f\n', index_dest, vert_dest);

%% Check leadfields
H_source = aet_source_get_gain(index_source, head_source);
H_dest = aet_source_get_gain(index_dest, head_dest);

% Remove nans
for i=1:ncomp
    H_source(isnan(H_source(:,i)),i) = 0;
    H_dest(isnan(H_dest(:,i)),i) = 0;
end

fprintf('leadfield difference: %f\n', norm(H_source - H_dest, 'fro'))
figure;
imagesc(H_source - H_dest);
colorbar;