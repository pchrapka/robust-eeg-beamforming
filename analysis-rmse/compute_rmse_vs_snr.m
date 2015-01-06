function [cfg] = compute_rmse_vs_snr(cfg)
%
%   cfg.beam_cfgs
%       cell array of beamformer configs
%   cfg.snrs
%       array of input data snrs
%   cfg.metrics
%       struct specifying rmse metric specification
%   
%       location_idx
%           location to use in RMSE calculation
%       sample_idx
%           samples to use in RMSE calculation
%       component
%           selects signal component for RMSE calculation: signal,
%           interference, noise
%       see METRICS.RMSE_SELECT and METRICS.RMSE
%   
%   cfg.force
%       flag for forcing recomputation of metrics, default = false
%   cfg.data_set
%       struct describing data set
%   
%       example:
%       cfg.data_set.sim_name = 'sim_data_bem_1_100t';
%       cfg.data_set.source_name = 'mult_cort_src_17';
%       cfg.data_set.snr = 0;
%       cfg.data_set.iteration = '1';
%
%   cfg.save_tag
%       tag for saving the data

debug = true;

if ~isfield(cfg, 'force'), cfg.force = false; end

% Set up the output file name based on data set
data_file = metrics.filename(cfg);

% Set up metrics dir in data set dir
out_dir = 'metrics';
cfg_out = [];
cfg_out.file_name = data_file;
cfg_out.save_name = [filesep out_dir filesep...
    'rmse_vs_inputsnr_' cfg.metrics.component '_loc'...
    num2str(cfg.metrics.location_idx)];
cfg_out.tag = cfg.save_tag;
cfg_out.ext = '.mat';
% Generate file name
cfg.data_file = db.save_setup(cfg_out);

% Check if the data exists
if ~exist(cfg.data_file, 'file') || cfg.force
    % Compute the RMSE if the file doesn't exist
    
    % Set up output
    output = [];
    output.bf_name = cfg.beam_cfgs;
    output.data = zeros(length(cfg.snrs), 1+length(cfg.beam_cfgs));
    
    % Loop over beamformers
    for m=1:length(cfg.beam_cfgs)
        
        % Loop through snrs
        for i=1:length(cfg.snrs)
            % Set the snr
            snr = cfg.snrs(i);
            cfg.data_set.snr = snr;
            
            %% Compute beamformer output of individual components
            % Select beamformer
            cfg.beam_cfg = cfg.beam_cfgs{m};
            cfg_copy = cfg;
            cfg_copy = beamform_components(cfg_copy);
            din = load(cfg_copy.data_file);
            bf_out = din.data.bf_out;
            clear din;
            
            %% Calculate normalizing factor for total beamformer output
            % Load the beamformer output data
            cfg.data_set.tag = cfg.beam_cfg;
            file_name = db.get_full_file_name(cfg.data_set);
            file_name = strcat(file_name, '.mat');
            dbf = load(file_name);
            
            % Load the original EEG data
            cfg.data_set.tag = [];
            file_name = db.get_full_file_name(cfg.data_set);
            file_name = strcat(file_name, '.mat');
            din = load(file_name);

            % Set up struct to select data
            cfg_rmse_select = cfg.metrics; % copy location_idx and sample_idx
            cfg_rmse_select.bf_out = dbf.source.beamformer_output;
            cfg_rmse_select.bf_in = din.data.avg_dipole_signal;
            
            % Select data for RMSE calculation
            output_select = metrics.rmse_select(cfg_rmse_select);
            
            % Calculate alpha
            cfg_rmse = [];
            cfg_rmse.normalize = true;
            cfg_rmse.bf_out = output_select.bf_out_select';
            cfg_rmse.input = output_select.bf_in_select';
            output_rmse = metrics.rmse(cfg_rmse);
            alpha = output_rmse.rmse_alpha;
            
            if debug
                h = figure;
                n_plots = 2;
                k = 1;
                subplot(n_plots,1,k);
                
                pow_output = sqrt(sum(cfg_rmse.bf_out.^2,2));
                pow_input = sqrt(sum(cfg_rmse.input.^2,2));
                
                subplot(n_plots,1,k);
                plot(1:length(pow_output), pow_output,...
                    1:length(pow_input), pow_input);
                k = k+1;
                title(['total power scaled ' cfg.beam_cfg ' snr: ' num2str(snr)]);
                legend('output', 'input');
                ylabel('not scaled');
                
                subplot(n_plots,1,k);
                plot(1:length(pow_output), alpha*pow_output,...
                    1:length(pow_input), pow_input);
                k = k+1;
                legend('output', 'input');
                ylabel('scaled');
                close(h);
            end
            
            %% Compute rmse for the selected component 
            % using a common normalizing factor
            
            % Set up rmse cfg
            cfg_rmse = [];
            cfg_rmse.normalize = true;
            cfg_rmse.alpha = alpha;
            
            % Set up struct to select data
            cfg_rmse_select = cfg.metrics; % copy location_idx and sample_idx
            cfg_rmse_select.bf_in = din.data.avg_dipole_signal;
            % Select data for RMSE calculation
            output_select = metrics.rmse_select(cfg_rmse_select);
            cfg_rmse.input = output_select.bf_in_select';
            
            % Set up struct to select output data
            % NOTE The data is in a different format, so we need to make
            % some adjustments
            cfg_rmse_select = cfg.metrics;
            cfg_rmse_select.location_idx = 1;
            in_size = size(din.data.avg_dipole_signal);
            % Select component
            switch cfg.metrics.component
                case 'signal'
                    cfg_rmse_select.bf_out = reshape(...
                        bf_out.signal.data{cfg.metrics.location_idx},...
                        [in_size(1), 1, in_size(3)]);
                    
                    % Add noise
                    noise_data = reshape(...
                        bf_out.noise.data{cfg.metrics.location_idx},...
                        [in_size(1), 1, in_size(3)]);
                    
                    cfg_rmse_select.bf_out = cfg_rmse_select.bf_out + noise_data;
                case 'interference'
                    cfg_rmse_select.bf_out = reshape(...
                        bf_out.interference.data{cfg.metrics.location_idx},...
                        [in_size(1), 1, in_size(3)]);
                    
                    % Add noise
                    noise_data = reshape(...
                        bf_out.noise.data{cfg.metrics.location_idx},...
                        [in_size(1), 1, in_size(3)]);
                    
                    cfg_rmse_select.bf_out = cfg_rmse_select.bf_out + noise_data;
                case 'noise'
                    cfg_rmse_select.bf_out = reshape(...
                        bf_out.noise.data{cfg.metrics.location_idx},...
                        [in_size(1), 1, in_size(3)]);
                otherwise
                    error(['reb:' mfilename],...
                        'unknown component %s\n',cfg.metrics.component);
            end
            
            % Select data for RMSE calculation
            output_select = metrics.rmse_select(cfg_rmse_select);
            cfg_rmse.bf_out = output_select.bf_out_select';

            % Calculate RMSE of component
            output_rmse = metrics.rmse(cfg_rmse);
            
            % Extract the output
            output.data(i,1) = snr;
            rmse = [output_rmse.rmse_x output_rmse.rmse_y output_rmse.rmse_z];
            output.data(i,1+m) = norm(rmse);
            
            if debug
                h = figure;
                n_plots = 4;
                k = 1;
                subplot(n_plots,1,k);
                plot(1:size(cfg_rmse.bf_out,1), cfg_rmse.alpha*cfg_rmse.bf_out(:,1),...
                    1:size(cfg_rmse.input,1), cfg_rmse.input(:,1));
                ylabel(sprintf('x %0.4f', output_rmse.rmse_x));
                k = k+1;
                legend('output', 'input');
                title({['raw scaled ' cfg.metrics.component],...
                    [cfg.beam_cfg ' snr: ' num2str(snr)]});
                
                subplot(n_plots,1,k);
                plot(1:size(cfg_rmse.bf_out,1), cfg_rmse.alpha*cfg_rmse.bf_out(:,2),...
                    1:size(cfg_rmse.input,1), cfg_rmse.input(:,2));
                ylabel(sprintf('y %0.4f', output_rmse.rmse_y));
                k = k+1;
                
                subplot(n_plots,1,k);
                plot(1:size(cfg_rmse.bf_out,1), cfg_rmse.alpha*cfg_rmse.bf_out(:,3),...
                    1:size(cfg_rmse.input,1), cfg_rmse.input(:,3));
                ylabel(sprintf('z %0.4f', output_rmse.rmse_z));
                k = k+1;
                
                pow_output = sqrt(sum(cfg_rmse.bf_out.^2,2));
                pow_input = sqrt(sum(cfg_rmse.input.^2,2));
                subplot(n_plots,1,k);
                plot(1:length(pow_output), cfg_rmse.alpha*pow_output,...
                    1:length(pow_input), pow_input);
                k = k+1;
                legend('output', 'input');
                ylabel(sprintf('power %0.4f', norm(rmse)));
                close(h);
            end
            
        end
        
        % Set line style based on bf name
        if ~isempty(strfind(output.bf_name{m}, 'rmv'))
            output.line_style{m} = '--';
        elseif ~isempty(strfind(output.bf_name{m}, 'lcmv_eig'))
            output.line_style{m} = ':';
        else
            output.line_style{m} = '-';
        end
        % Fix the legend label
        output.bf_name{m} = util.fix_label(output.bf_name{m});
    end
    
    % Save output data
    fprintf('Saving %s\n', cfg.data_file);
    save(cfg.data_file, 'output');
    
end

end