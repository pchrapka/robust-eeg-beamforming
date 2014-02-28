function gen_uncertainty_data(cfg)
%GEN_UNCERTAINTY_DATA Generates the uncertainty matrices for the anisotropic rmv
%   GEN_UNCERTAINTY_DATA(CFG)
%
%   cfg.head    specifices the head models
%     actual    cfg specifying the actual head model
%       type    'fieldtrip' or 'brainstorm'
%       file    name of file to be retrieved
%     estimate  cfg specifying the estimate head model
%       type    'fieldtrip' or 'brainstorm'
%       file    name of file to be retrieved
%
%   cfg.force   forces recreation of the uncertainty data

% Set the output dir
output_dir = 'output';

% Set the output file name
[~,actual_name,~,~] = fileparts_phil(cfg.head.actual.file);
[~,est_name,~,~] = fileparts_phil(cfg.head.estimate.file);

out_file = ['uncert_' actual_name '_' est_name '.mat'];
data_file = fullfile(output_dir, out_file);

% Check if it exists
if ~exist(data_file, 'file') || cfg.force
    
    % Get the head model data
    H_actual = hm_get_data(cfg.head.actual);
    H_estimate = hm_get_data(cfg.head.estimate);
    
    % Generate the uncertainty data
    A = aet_analysis_rmv_uncertainty_create(H_actual, H_estimate);
    
    % Save the data
    save(data_file, 'A');
    
end

end