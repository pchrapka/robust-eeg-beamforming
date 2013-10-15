%% simulation_ex1_snr.m -- Example 1: Exactly known leadfield matrix
% Performs an analysis of the robust beamformer for an exactly known
% leadfield matrix with varying levels of SNR. It is also compared with the
% LCMV beamformer

function simulation_ex1_snr(cfg)

% Load the simulation parameters
eval(cfg.sim_data);
eval(cfg.sim_src_parameters);
eval(cfg.sim_beam);

%% Set up beamformer parameters
cfg_beamspace.n_evalues = sim_cfg.n_evalues;
cfg_beamspace.head_model = sim_cfg.head;
beamspace_data = aet_analysis_beamspace_cfg(cfg_beamspace);

beam_cfg.loc = sim_cfg.sources{1}.source_index;
beam_cfg.epsilon = sim_cfg.epsilon;
beam_cfg.lambda = 0; % Set later
beam_cfg.n_interfering_sources = sim_cfg.n_interfering_sources;
beam_cfg.types = sim_cfg.beamformer_types;
beam_cfg.T = beamspace_data.T;
beam_cfg = set_up_beamformers(beam_cfg);

%% Set up the output struct

out_cfg.beam_cfg = beam_cfg;
out_cfg.x_size = [length(sim_cfg.snr_range) sim_cfg.n_runs];
out_cfg.y_size = [length(sim_cfg.snr_range) sim_cfg.n_runs];
out_cfg.y_label = 'Output SINR (dB)';
out_cfg.x_label = 'SNR (dB)';
out = set_up_output(out_cfg);

%% Run simulation

for i=1:length(sim_cfg.snr_range)
    cur_snr = sim_cfg.snr_range(i);
    fprintf('\nSNR: %d \n', cur_snr);
    
    progbar = progressBar(sim_cfg.n_runs,'Thinking');
    for j=1:sim_cfg.n_runs
        % Update progress bar
        progbar(j);
        
        % Create the file name
        data_file = [...
            sim_cfg.out_dir filesep...
            sim_cfg.sim_name '_'...
            sim_cfg.source_name '_'...
            num2str(cur_snr) '_'...
            num2str(j) '.mat'...
            ];
        % Load the data
        load(data_file);
        
        % Calculate the covariance
        R = cov(data.avg_trials');
        
        for k=1:length(beam_cfg)
            % Set lambda for lcmv_reg
            if isequal(beam_cfg(k).type,'lcmv_reg')
                lambda_cfg.R = R;
                lambda_cfg.multiplier = 0.005;
                beam_cfg(k).lambda = aet_analysis_beamform_get_lambda(...
                    lambda_cfg);
%                   beam_cfg(k).lambda = 10*trace(cov(data.avg_noise'));
            end
            
            % Run the beamformer
            beam_cfg(k).R = R;
            beam_cfg(k).head_model = sim_cfg.head;
            beam_out = aet_analysis_beamform(beam_cfg(k));
            
            % Save the data SNR
            out(k).x(i,j) = sim_cfg.snr_range(i);
            out(k).status{i,j} = beam_out.opt_status;
            
            if isequal(beam_out.opt_status, 'Solved')
                % Calculate the output of the beamformer with different data
                beam_cfg(k).W = beam_out.W;
                signal = aet_analysis_beamform_output(...
                    beam_cfg(k), data.avg_signal);
                interference = aet_analysis_beamform_output(...
                    beam_cfg(k), data.avg_interference);
                noise = aet_analysis_beamform_output(...
                    beam_cfg(k), data.avg_noise);
                
                % Calculate the SINR
                out(k).y(i,j) = calc_sinr(signal, interference, noise);
            else
                % No output
                out(k).y(i,j) = NaN;
            end
        end
    end
end

%% Save the output data
sim_cfg.data_type = cfg.sim_file_out;
aet_save(sim_cfg, out);

% Required output
% SINR vs SNR - need to repeat simulation over different values of SNR
% SINR vs epsilon, SNR = -10dB, depending on results of first experiment
end