%% print_beamformer_constraint

beam_files = {...
    '20_1_lcmv_locs2_covtrial_s1-250.mat',...
    '20_1_lcmv_locs2_covtrial_s1-250_3sphere.mat',...
    '20_1_rmv_epsilon_150_locs2_covtrial_s1-250_3sphere.mat',...
    '20_1_rmv_aniso_locs2_covtrial_s1-250_3sphere.mat',...
    };

% type = 'current';
type = 'actual';
for i=1:length(beam_files)
    fprintf('head model type: %s\n',type);
    loc_idx = 295;
    bf_file = fullfile('output',...
        'sim_data_bem_1_100t_250s_keeptrials_snrpertrial',...
        'mult_cort_src_17_lag40',...
        beam_files{i});
    load(bf_file);
    
    hm = load_hm_from_beamformer_file(bf_file,'type',type);
    H = hm.get_leadfield(loc_idx);
    
    idx = find(source.loc == loc_idx);
    W = source.filter{idx};
    
    print_msg_filename(bf_file,'W^T H for ');
    disp(W'*H);
end