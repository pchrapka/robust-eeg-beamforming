
%% Options
% highres_model = 'head_Colin27_bem_vol_30000V.mat';
% highres_model = 'head_Colin27_bem_surf_15000V.mat';
% highres_model = 'head_Default1_bem_15028V.mat';
highres_model = 'head_Default1_bem_500V.mat';
manual = false; % option to manually select the ROI
plotdb = false;

% NOTE Compare apples to apples, i.e. you have to compute the beampattern
% using the actual head model used for simulation and analysis

%% Select beampattern ROI
roi_idx = select_beampattern_roi(highres_model, manual);

% Check selected indices

hmfactory = HeadModel();
hm_highres = hmfactory.createHeadModel('brainstorm',highres_model);
hm_highres.load();

head_roi = hm_highres.data;
head_roi.GridLoc = hm_highres.data.GridLoc(roi_idx,:);

figure;
plot_brainstorm_grid(head_roi,20,'red','o','filled');
title('ROI High Resolution');
axis equal

%% Options for beampattern
voxel_idx = 295;
interference_idx = 400;
snr = 0;

%% Calculate the beampattern
% beam_cfgs = {...
%     'rmv_epsilon_150_3sphere',...
%     ...'lcmv_eig_1_3sphere',...
%     'lcmv_3sphere',...
%     };
beam_cfgs = {...
    'rmv_epsilon_20',...
    ...'lcmv_eig_1_3sphere',...
    'lcmv',...
    };
n_data = length(beam_cfgs);

% Set up simulation info

data_set = SimDataSetEEG(...
    'sim_data_bem_1_100t',...
    'mult_cort_src_17',...
    snr,...
    'iter',1);

% Extract x coordinates from head model
x = hm_highres.data.GridLoc(roi_idx,1);
x = x(:);
cc=jet(n_data);

figure;
hold on;
bfname = cell(n_data,1);
for j=1:n_data
    
    tag = [beam_cfgs{j}]; % No mini tag
    beamformer_file = db.save_setup('data_set',data_set,'tag',tag);
    
    % Load the beamformer output data
    data_in = load(beamformer_file);
    
    % Get index of voxel location in the data array
    W = data_in.source.filter{data_in.source.loc == voxel_idx};
    nchannels = size(W,1);
    
    n_locs = length(roi_idx);
    % Allocate memory
    beamnorm = zeros(n_locs,1);
    beamtrace = zeros(n_locs,1);
    
    % Loop through selected points
    for i=1:n_locs
        H = hm_highres.get_leadfield(roi_idx(i));
        if nchannels < size(H,1)
           H = H(1:nchannels,:); 
        end
        
        % Calculate the beampattern
        beamnorm(i) = norm(W'*H, 'fro');
        beamtrace(i) = trace(W'*H);
        
        % Sanity check for known source
        if x(i) == vert_source(1)
            H_highres = H;
            H_orig = data_in.source.leadfield{data_in.source.loc == voxel_idx};
            disp(norm(H_highres - H_orig, 'fro'));
        end
    end
    
    % Combine the beampattern with the x coord
    y = beamnorm(:);
    if plotdb
        y = db(y);
    end
    data = [x y];
    % Sort based on x coordinate
    data = sortrows(data,1);
    % Plot the beampattern
    subplot(2,1,1);
    hold on;
    plot(data(:,1),data(:,2),'color',cc(j,:),'marker','+');
    ylabel('Frobenius norm');
    
    % Combine the beampattern with the x coord
    y = beamtrace(:);
    if plotdb
        y = db(y);
    end
    data = [x y];
    % Sort based on x coordinate
    data = sortrows(data,1);
    subplot(2,1,2);
    hold on;
    plot(data(:,1),data(:,2),'color',cc(j,:),'marker','+');
    ylabel('Trace');
    
%     % Save the beamformer name for the legend
%     bfname{j} = beam_cfgs{j};
end
legend(beam_cfgs);

%% Add the source
% Load head model used for simulation
hmfactory = HeadModel();
hm_orig = hmfactory.createHeadModel('brainstorm','head_Default1_bem_500V.mat');

% Load source vertex
[vert_idx, vert_source] = hm_orig.get_vertices('type','index','idx',295);

x = [vert_source(1) vert_source(1)];
subplot(2,1,1);
y = ylim;
hold on;
line(x,y,'color','black');

subplot(2,1,2);
y = ylim;
hold on;
line(x,y,'color','black');