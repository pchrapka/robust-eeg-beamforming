%% power_surface_highres
% Beamformer output power plotted on the cortex at a particular point in
% time, using a high resolution head model.
%
% These are the plots used in the paper
%
% See also, RUN_ALL_PAPER

k = 1;
params = [];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Mult17HD
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

params(k).source_name = 'mult_cort_src_17hd';
params(k).snr =  0;
params(k).time = 0.520;
params(k).sample = params(k).time*250 + 1;
k = k+1;

params(k) = params(k-1);
params(k).matched = false;
k = k+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Single1HD
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

params(k).source_name = 'single_cort_src_1hd';
params(k).snr =  0;
params(k).time = 0.476;
params(k).sample = params(k).time*250 + 1;
k = k+1;

params(k) = params(k-1);
params(k).matched = false;
k = k+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Distr2HD
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

params(k).source_name = 'distr_cort_src_2hd';
params(k).snr =  0;
params(k).time = 0.464;
params(k).sample = params(k).time*250 + 1;
params(k).matched = true;
k = k+1;

params(k) = params(k-1);
params(k).matched = false;
k = k+1;

%% Compute beamformer output power
for i=1:length(params)
    cfg = get_power_surface_config(...
        'highres',...
        params(i).source_name, ...
        params(i).matched,...
        params(i).snr);
    
    % Plot data
    plot_power_surface(...
        cfg.data_set,...
        cfg.beam_cfgs,...
        'sample', params(i).sample,...
        cfg.args{:});
end