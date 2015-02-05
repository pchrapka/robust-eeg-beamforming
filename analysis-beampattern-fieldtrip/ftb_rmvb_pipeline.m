debug = false;
stage = [];

% restart_stage = 'L5mm';
% restart_stage = 'L10mm';
% restart_stage = 'Lliny10mm';
% restart_stage = 'SM1snr0';
% restart_stage = 'SS1snr0';
% restart_stage = 'SN1';
% ftb.clean_data(restart_stage);

%% Stage 1
% Create a bemcp head model
% headmodel = 'HMbemcp';
% Create an openmeeg head model
headmodel = 'HMopenmeeg';
% Most accurate according to: https://hal.inria.fr/hal-00776674/document

stage.headmodel = headmodel;
% Get the config
cfg = ftb.prepare_headmodel(stage);
% Create the model
cfg = ftb.create_headmodel(cfg);

%% Stage 2
% Create aligned electrodes
electrodes = 'E256';
stage.electrodes = electrodes;
% Get the config
cfg = ftb.prepare_electrodes(stage);
% Create the model
cfg = ftb.create_electrodes(cfg);

%% Stage 3
% Create leadfield
% leadfield = 'L1mm';
% leadfield = 'L1cm';
% leadfield = 'L5mm';
% leadfield = 'L10mm';
% leadfield = 'Llinx10mm';
% leadfield = 'Lliny10mm';
leadfield = 'Lliny1mm';
% leadfield = 'Lsurf10mm';

stage.leadfield = leadfield;
% Get the config
cfg = ftb.prepare_leadfield(stage);
% Create the model
cfg = ftb.create_leadfield(cfg);

% ftb.check_leadfield(cfg);

%% Stage 4
% Create simulated data
% dipolesim = 'SM1snr0';
dipolesim = 'SS1snr0';
% dipolesim = 'SN1';

stage.dipolesim = dipolesim;
% Get the config
cfg = ftb.prepare_dipolesim(stage);
% Create the model
cfg = ftb.create_dipolesim(cfg);

% ftb.check_dipolesim(cfg);

%% Stage 5
% Source localization
beamformers = {...
    'BFlcmv',...
    'BFlcmv_reg',...
    'BFlcmv_eig1',...
    'BFlcmv_eig2',...
    ...'BFrmvb256_eps200',...
    ...'BFrmvb256_epsd25',...
    'BFrmvb256_epsd025',...
    };

for i=1:length(beamformers)
    beamformer = beamformers{i};
    stage.beamformer = beamformer;
    % Get the config
    cfg = ftb.prepare_sourceanalysis(stage);
    % Create the model
    cfg = ftb.create_sourceanalysis(cfg);
end

% Check results
cfg.checks = {'anatomical', 'headmodel', 'scatter'};
cfg.method = 'all';
% cfg.checks = {'headmodel', 'scatter'};
% cfg.checks = {'scatter'};
% cfg.method = 'outer';
% cfg.outer.size = 15;
% cfg.method = 'plane';
% cfg.plane.axis = 'x';
% cfg.plane.value = -50;
% ftb.check_sourceanalysis(cfg);

% %% Stage 4b
% % Simulate noise for contrast plot
% dipolesimnoise = 'SN1';
% 
% stage.dipolesim = dipolesimnoise;
% % Get the config
% cfg = ftb.prepare_dipolesim(stage);
% % Create the model
% cfg = ftb.create_dipolesim(cfg);

% %% Stage 5b
% % Source localization with noise only
% stage.beamformer = beamformer;
% % Get the config
% cfg = ftb.prepare_sourceanalysis(stage);
% % Create the model
% cfg = ftb.create_sourceanalysis(cfg);
% 
% %% Stage 5c
% % Check results with noise contrast
% stage.dipolesim = dipolesim;
% stage.beamformer = beamformer;
% % Get the config
% cfg = ftb.prepare_sourceanalysis(stage);
% 
% % Check results with contrast
% cfgcopy = cfg;
% cfgcopy.contrast = dipolesimnoise;
% cfgcopy.checks = {'anatomical', 'headmodel', 'scatter'};
% ftb.check_sourceanalysis(cfgcopy);

%% Stage 6
% Analysis
cfgtmp = ftb.get_stage(cfg,'dipolesim');
cfgdp = ftb.load_config(cfgtmp.stage.full);
pos = cfgdp.signal.ft_dipolesimulation.dip.pos;

cfgtmp = ftb.get_stage(cfg,'leadfield');
cfglf= ftb.load_config(cfgtmp.stage.full);
leadfield = ftb.util.loadvar(cfglf.files.leadfield);

power.xdata = [];
power.ydata = [];
for i=1:length(beamformers)
    
    cfg.stage.beamformer = beamformers{i};
    cfgtmp = ftb.get_stage(cfg,'beamformer');
    cfgsource = ftb.load_config(cfgtmp.stage.full);
    source = ftb.util.loadvar(cfgsource.files.ft_sourceanalysis.all);
    
    % Gather power data
    data = source.avg.pow(:);
    power.ydata(:,i) = data/max(data);
    power.xdata(:,i) = source.pos(:,2);
    
    % Gather beampattern data
    [~,source_idx] = ismember(pos, source.pos, 'rows');
    filtsrc = source.avg.filter{source_idx}; % 3 x 256
    for j=1:length(leadfield.leadfield)
        lf = leadfield.leadfield{j};
        beampattern.ydata(j,i) = norm(filtsrc * lf, 'fro');
%         beampattern.ydata(j,i) = trace(filtsrc * lf);
    end
    beampattern.xdata(:,i) = source.pos(:,2);
    
    legend_str{i} = cfgsource.name;
end

figure;
plot(power.xdata, power.ydata);
legend(legend_str{:});
title('power normalized');

figure;
plot(beampattern.xdata, beampattern.ydata);
legend(legend_str{:});
title('beampattern');