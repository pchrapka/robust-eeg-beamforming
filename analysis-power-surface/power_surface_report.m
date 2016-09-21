%% power_surface_report_mult17hd

%% NOTES

% How to run
% 1. Upload code to blade using a terminal, ./upload.sh
% 2. Run power_surface_report in matlab. This will compute the power and
% generate figures as specified below
%
% How to create the report
% The report will be report-power-surface.org, which required emacs
% org-mode to compile. Blade doesn't have latex / org-mode so this can be
% done on another computer.
% 1. Download the image files ./dl-img.sh
% 2. Download the org files ./dl-org.sh
% 3. Open the report in emacs and press C-c C-e l o to publish a pdf

%% Generate data
% run_sim_vars_bemhd_mult17hd

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SNR = 0
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Compute beamformer output power - matched

matched = true;
snr = 0;
cfgmatched = get_power_surface_config('highres','mult_cort_src_17hd', matched, snr);
% Compute the beamformer output power
cfgmatched.outputfile = compute_power(cfgmatched.data_set, cfgmatched.beam_cfgs);

%% Compute beamformer output power - mismatched

matched = false;
snr = 0;
cfgmismatched = get_power_surface_config('highres','mult_cort_src_17hd', matched, snr);
% Compute the beamformer output power
cfgmismatched.outputfile = compute_power(cfgmismatched.data_set, cfgmismatched.beam_cfgs);

%% Set up report
analysisdir = 'analysis-power-surface';
report = report_setup(fullfile(analysisdir, 'report-power-surface.org'));

%% Plot data

time = 0.520;
sample = time*250 + 1;

samples = 120:140;
for i=1:length(samples)
    
    outfile_matched = view_power_surface_relative(...
        cfgmatched.data_set,...
        cfgmatched.outputfile,...
        'sample',samples(i),...
        cfgmatched.args{:});
    
    outfile_mismatched = view_power_surface_relative(...
        cfgmismatched.data_set,...
        cfgmismatched.outputfile,...
        'sample',samples(i),...
        cfgmismatched.args{:});
    
    % Add heading
    report_add_heading(report, ['Sample ' num2str(samples(i))], 1);
    
    % Add a figure into the report
    fig = report_figure_matched_mismatched(outfile_matched, outfile_mismatched);
    report_add_fig(report, fig);
    
end
