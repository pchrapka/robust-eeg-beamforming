function [cfg] = compute_sinr_vs_snr(cfg)
%
%   cfg.beam_cfgs
%       cell array of beamformer configs
%   cfg.snrs
%       array of input data snrs
%   cfg.metrics
%       struct specifying sinr metric specification
%   cfg.force
%       flag for forcing recomputation of metrics, default = false
%   cfg.save_tag
%       tag for saving the data

if ~isfield(cfg, 'force'), cfg.force = false; end

% Set up the output file name based on data set
cfg.file_type = 'metrics'; % Set up a new metrics subdir
data_file = metrics.filename(cfg);
cfg_out = [];
cfg_out.file_name = data_file;
cfg_out.save_name = [filesep...
    'metrics_outputsinr_vs_inputsnr_loc'...
    num2str(cfg.metrics.location_idx)];
cfg_out.tag = cfg.save_tag;
cfg_out.ext = '.mat';
% Generate file name
cfg.data_file = db.save_setup(cfg_out);

% Check if the data exists
if ~exist(cfg.data_file, 'file') || cfg.force
    % Compute the SINR if the file doesn't exist
    
    % Set up output
    output = [];
    output.bf_name = cfg.beam_cfgs;
    output.data = zeros(length(cfg.snrs), 1+length(cfg.beam_cfgs));
    
    % Loop over beamformers
    for m=1:length(cfg.beam_cfgs)
        
        % Loop through snrs
        for i=1:length(cfg.snrs)
            snr = cfg.snrs(i);
            
            % Select beamformer
            cfg.beam_cfg = cfg.beam_cfgs{m};
            
            % Calculate the metrics
            cfg.metrics.name = 'sinr';
            cfg.data_set.snr = snr;
            out = metrics.run_metrics_on_file(cfg);
            
            % Extract the output
            output.data(i,1) = out.metrics(1).output.snrdb;
            output.data(i,1+m) = out.metrics(1).output.sinrdb;
            
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