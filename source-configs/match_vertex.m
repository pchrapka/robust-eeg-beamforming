% Script to match a vertex in different head models
headfile_source = 'head_Default1_bem_500V.mat';
headfile_dest = 'head_Default1_bem_15028V.mat';

% index_source = 295;
index_source = 400;

%% Load head models
% Load source head model
hmfactory = HeadModel();
hm_source = hmfactory.createHeadModel('brainstorm',headfile_source);
hm_source.load();

% Load destination head model
hmfactory = HeadModel();
hm_dest = hmfactory.createHeadModel('brainstorm',headfile_dest);
hm_dest.load();

%% Get source vertex
[vert_idx, vert_source] = hm_source.get_vertices('type','index','idx',index_source);

%% Find matching vertex in destination head model
ncomp = length(vert_source);
nvert = size(hm_dest.data.GridLoc,1);

sel = ones(nvert, 1);
for i=1:ncomp
    sel = sel & (hm_dest.data.GridLoc(:,i) == vert_source(i));
end

index_dest = find(sel > 0);
if isempty(index_dest)
    error('reb:match_vertex',...
        'no matching vertex');
end

%% Get dest vertex
[vert_idx, vert_dest] = hm_dest.get_vertices('type','index','idx',index_dest);

%% Print results
fprintf('old\n\tindex: %d\n\tvertex: %f %f %f\n', index_source, vert_source);
fprintf('new\n\tindex: %d\n\tvertex: %f %f %f\n', index_dest, vert_dest);

%% Check leadfields
H_source = hm_source.get_leadfield(index_source);
H_dest = hm_source.get_leadfield(index_dest);

% Remove nans
for i=1:ncomp
    H_source(isnan(H_source(:,i)),i) = 0;
    H_dest(isnan(H_dest(:,i)),i) = 0;
end

fprintf('leadfield difference: %f\n', norm(H_source - H_dest, 'fro'))
figure;
imagesc(H_source - H_dest);
colorbar;