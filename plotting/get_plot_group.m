function params = get_plot_group(name, datatag)

params.name = name;
params.datatag = datatag;
switch name
    case 'matched-paper'
        params.beamformer_configs = {...
            ['rmv_epsilon_20_' datatag],...
            ['lcmv_' datatag],...
            ...['lcmv_eig_cov_0_' datatag],...
            ...['lcmv_eig_cov_1_' datatag],...
            ...['lcmv_eig_cov_leadfield_1_' datatag],... temp
            ...['lcmv_eig_filter_1_' datatag],... temp
            ['lcmv_eig_filter_2_' datatag],... temp
            ['lcmv_reg_eig_' datatag],...
            };
        params.tag = '-paper';
        params.matched = true;
        
    case 'matched-beampattern'
        params.beamformer_configs = {...
            ['rmv_epsilon_20_' datatag],...
            ['lcmv_' datatag],...
            ...['lcmv_eig_cov_0_' datatag],...
            ...['lcmv_eig_cov_1_' datatag],...
            ...['lcmv_eig_filter_1_' datatag],...
            ['lcmv_eig_filter_2_' datatag],...
            ['lcmv_reg_eig_' datatag],...
            };
        params.tag = '-beampattern';
        params.matched = true;
        
    case 'matched-power'
        params.beamformer_configs = {...
            ...['rmv_epsilon_10_' datatag],...
            ['rmv_epsilon_20_' datatag],...
            ...['rmv_epsilon_30_' datatag],...
            ...['rmv_epsilon_40_' datatag],...
            ...['rmv_epsilon_50_' datatag],...
            ...['rmv_eig_pre_cov_0_epsilon_20_' datatag],...
            ...['rmv_eig_pre_cov_1_epsilon_20_' datatag],...
            ['lcmv_' datatag],...
            ...['lcmv_eig_cov_0_' datatag],...
            ...['lcmv_eig_cov_1_' datatag],...
            ...['lcmv_eig_filter_1_' datatag],...
            ['lcmv_eig_filter_2_' datatag],...
            ['lcmv_reg_eig_' datatag],...
            };
        params.tag = '-power';
        params.matched = true;
        
    case 'matched-eig'
        params.beamformer_configs = {...
            ['rmv_epsilon_20_' datatag],...
            ['lcmv_' datatag],...
            ['lcmv_eig_cov_0_' datatag],...
            ['lcmv_eig_cov_1_' datatag],...
            ['lcmv_eig_filter_0_' datatag],...
            ['lcmv_eig_filter_1_' datatag],...
            ['lcmv_eig_cov_leadfield_0_' datatag],...
            ['lcmv_eig_cov_leadfield_1_' datatag],...
            ['lcmv_reg_eig_' datatag],...
            };
        params.tag = '-eig';
        params.matched = true;
            
    case 'matched-eig-lcmv'
        params.beamformer_configs = {...
            ['lcmv_' datatag],...
            ['lcmv_eig_cov_0_' datatag],...
            ['lcmv_eig_cov_1_' datatag],...
            ['lcmv_eig_cov_2_' datatag],...
            ['lcmv_eig_cov_3_' datatag],...
            ['lcmv_eig_cov_4_' datatag],...
            ['lcmv_reg_eig_' datatag],...
            };
        params.tag = '-eig-lcmv';
        params.matched = true;
        
    case 'matched-eigfilter-lcmv'
        params.beamformer_configs = {...
            ['lcmv_' datatag],...
            ['lcmv_eig_filter_0_' datatag],...
            ['lcmv_eig_filter_1_' datatag],...
            ['lcmv_eig_filter_2_' datatag],...
            ['lcmv_eig_filter_3_' datatag],...
            ['lcmv_eig_filter_4_' datatag],...
            ['lcmv_reg_eig_' datatag],...
            };
        params.tag = '-eigfilter-lcmv';
        params.matched = true;
            
    case 'matched-eig-rmv'
        params.beamformer_configs = {...
                ['rmv_epsilon_20_' datatag],...
                ['rmv_eig_pre_cov_0_epsilon_20_' datatag],...
                ['rmv_eig_pre_cov_1_epsilon_20_' datatag],...
                ['rmv_eig_post_1_epsilon_20_' datatag],...
                ['lcmv_' datatag],...
                ['lcmv_reg_eig_' datatag],...
                };
            params.tag = '-eig-rmv';
            params.matched = true;
            
    case 'mismatched-paper'
        params.beamformer_configs = {...
                ['rmv_epsilon_100_' datatag '_3sphere'],...
                ['rmv_epsilon_150_' datatag '_3sphere'],...
                ['rmv_epsilon_200_' datatag '_3sphere'],...
                ['rmv_aniso_mult_0-10_c_20_' datatag '_3sphere'],...
                ['lcmv_' datatag '_3sphere'],...
                ...['lcmv_eig_cov_0_' datatag '_3sphere'],...
                ...['lcmv_eig_cov_1_' datatag '_3sphere'],...
                ...['lcmv_eig_filter_1_' datatag '_3sphere'],...
                ['lcmv_eig_filter_2_' datatag '_3sphere'],...
                ['lcmv_reg_eig_' datatag '_3sphere'],...
                };
            params.tag = '-paper';
            params.matched = false;
            
    case 'mismatched-beampattern'
            params.beamformer_configs = {...
                ['rmv_epsilon_50_' datatag '_3sphere'],...
                ['rmv_epsilon_100_' datatag '_3sphere'],...
                ...['rmv_epsilon_125_' datatag '_3sphere'],...
                ['rmv_epsilon_150_' datatag '_3sphere'],...
                ...['rmv_epsilon_175_' datatag '_3sphere'],...
                ['rmv_epsilon_200_' datatag '_3sphere'],...
                ['rmv_aniso_mult_0-10_c_20_' datatag '_3sphere'],...
                ...['rmv_eig_pre_cov_1_epsilon_150_' datatag '_3sphere'],...
                ...['rmv_eig_post_1_epsilon_150_' datatag '_3sphere'],...
                ...['rmv_aniso_eig_pre_cov_1_' datatag '_3sphere'],...
                ...['rmv_aniso_eig_post_1_' datatag '_3sphere'],...
                ['lcmv_' datatag '_3sphere'],...
                ...['lcmv_eig_cov_0_' datatag '_3sphere'],...
                ...['lcmv_eig_cov_1_' datatag '_3sphere'],...
                ...['lcmv_eig_filter_1_' datatag '_3sphere'],...
                ['lcmv_eig_filter_2_' datatag '_3sphere'],...
                ['lcmv_reg_eig_' datatag '_3sphere'],...
                };
            params.tag = '-beampattern';
            params.matched = false;
            
    case 'mismatched-power'
        params.beamformer_configs = {...
            ['rmv_epsilon_50_' datatag '_3sphere'],...
            ['rmv_epsilon_100_' datatag '_3sphere'],...
            ['rmv_epsilon_150_' datatag '_3sphere'],...
            ...['rmv_epsilon_175_' datatag '_3sphere'],...
            ['rmv_epsilon_200_' datatag '_3sphere'],...
            ...['rmv_eig_pre_cov_0_epsilon_150_' datatag '_3sphere'],...
            ...['rmv_eig_pre_cov_1_epsilon_150_' datatag '_3sphere'],...
            ...['rmv_eig_post_1_epsilon_150_' datatag '_3sphere'],...
            ...['rmv_aniso_eig_pre_cov_1_' datatag '_3sphere'],...
            ...['rmv_aniso_eig_post_1_' datatag '_3sphere'],...
            ['rmv_aniso_mult_0-10_c_20_' datatag '_3sphere'],...
            ['lcmv_' datatag '_3sphere'],...
            ...['lcmv_eig_cov_0_' datatag '_3sphere'],...
            ...['lcmv_eig_cov_1_' datatag '_3sphere'],...
            ...['lcmv_eig_filter_1_' datatag '_3sphere'],...
            ['lcmv_eig_filter_2_' datatag '_3sphere'],...
            ['lcmv_reg_eig_' datatag '_3sphere'],...
            };
        params.tag = '-power';
        params.matched = false;
            
    case 'mismatched-eig'
        params.beamformer_configs = {...
            ['rmv_epsilon_150_' datatag '_3sphere'],...
            ['rmv_eig_pre_cov_0_epsilon_150_' datatag '_3sphere'],...
            ['rmv_eig_pre_cov_1_epsilon_150_' datatag '_3sphere'],...
            ['rmv_eig_post_1_epsilon_150_' datatag '_3sphere'],...
            ['rmv_aniso_eig_pre_cov_1_' datatag '_3sphere'],...
            ['rmv_aniso_eig_post_1_' datatag '_3sphere'],...
            ['rmv_aniso_mult_0-10_c_20_' datatag '_3sphere'],...
            ['lcmv_' datatag '_3sphere'],...
            ['lcmv_eig_cov_0_' datatag '_3sphere'],...
            ['lcmv_eig_cov_1_' datatag '_3sphere'],...
            ...['lcmv_eig_filter_0_' datatag '_3sphere'],... temp
            ...['lcmv_eig_filter_1_' datatag '_3sphere'],... temp
            ['lcmv_reg_eig_' datatag '_3sphere'],...
            };
        params.tag = '-eig';
        params.matched = false;
        
    case 'mismatched-paper-perturbed'
        perturb_tag = regexp(datatag,'perturb[\d\.]+','match');
        datatag2 = strrep(datatag, ['_' perturb_tag{1}],'');
        
        params.beamformer_configs = {...
            ['rmv_epsilon_100_' datatag2 '_3sphere'],...
            ['rmv_epsilon_150_' datatag2 '_3sphere'],...
            ['rmv_epsilon_200_' datatag2 '_3sphere'],...
            ['rmv_aniso_mult_0-10_c_20_' datatag '_3sphere'],...
            ['lcmv_' datatag2 '_3sphere'],...
            ...['lcmv_eig_cov_0_' datatag2 '_3sphere'],...
            ['lcmv_eig_cov_1_' datatag2 '_3sphere'],...
            ['lcmv_reg_eig_' datatag2 '_3sphere'],...
            };
        params.tag = '-paper-perturbed';
        params.matched = false;
        
    case 'mismatched-beampattern-perturbed'
        params.beamformer_configs = {...
            ['rmv_aniso_mult_0-10_c_20_' datatag '_3sphere'],...
            ['rmv_aniso_eig_pre_cov_1_' datatag '_3sphere'],...
            ['rmv_aniso_eig_post_1_' datatag '_3sphere'],...
            };
        params.matched = false;
        params.tag = '-beampattern-perturbed';
        
    case 'mismatched-power-perturbed'
        params.beamformer_configs = {...
            ['rmv_aniso_mult_0-10_c_20_' datatag '_3sphere'],...
            ['rmv_aniso_eig_pre_cov_1_' datatag '_3sphere'],...
            ['rmv_aniso_eig_post_1_' datatag '_3sphere'],...
            };
        params.matched = false;
        params.tag = '-power-perturbed';
        
    case 'mismatched-perturbed-eig'
        perturb_tag = regexp(datatag,'perturb[\d\.]+','match');
        datatag2 = strrep(datatag, ['_' perturb_tag{1}],'');
        
        params.beamformer_configs = {...
            ['rmv_epsilon_150_' datatag2 '_3sphere'],...
            ['rmv_eig_pre_cov_0_epsilon_150_' datatag2 '_3sphere'],...
            ['rmv_eig_pre_cov_1_epsilon_150_' datatag2 '_3sphere'],...
            ['rmv_eig_post_1_epsilon_150_' datatag2 '_3sphere'],...
            ['rmv_aniso_eig_pre_cov_1' datatag '_3sphere'],...
            ['rmv_aniso_eig_post_1' datatag '_3sphere'],...
            ['rmv_aniso' datatag '_3sphere'],...
            ['lcmv_' datatag2 '_3sphere'],...
            ['lcmv_eig_cov_0_' datatag2 '_3sphere'],...
            ['lcmv_eig_cov_1_' datatag2 '_3sphere'],...
            ...['lcmv_eig_filter_0_' datatag2 '_3sphere'],... temp
            ...['lcmv_eig_filter_1_' datatag2 '_3sphere'],... temp
            ['lcmv_reg_eig_' datatag2 '_3sphere'],...
            };
        params.tag = '-perturbed-eig';
        params.matched = false;
        
    case 'mismatched-paper-aniso-perturbed'
        params.beamformer_configs = {...
            ['rmv_aniso_mult_0-10_c_20_' datatag '_3sphere'],...
            ['rmv_aniso_random_varpct_0-02_' datatag '_3sphere'],...
            ['rmv_aniso_random_varpct_0-05_' datatag '_3sphere'],...
            ['rmv_aniso_random_varpct_0-10_' datatag '_3sphere'],...
            ['rmv_aniso_random_varpct_0-15_' datatag '_3sphere'],...
            };
        params.tag = '-perturbed-aniso';
        params.matched = false;
        
    case 'mismatched-paper-aniso-radius'
        params.beamformer_configs = {...
            ['rmv_epsilon_100_' datatag '_3sphere'],...
            ['rmv_epsilon_150_' datatag '_3sphere'],...
            ['rmv_epsilon_200_' datatag '_3sphere'],...
            ['rmv_aniso_mult_0-10_c_20_' datatag '_3sphere'],...
            ['rmv_aniso_radius_10_' datatag '_3sphere'],...
            ['lcmv_' datatag '_3sphere'],...
            ...['lcmv_eig_cov_0_' datatag '_3sphere'],...
            ...['lcmv_eig_cov_1_' datatag '_3sphere'],...
            ...['lcmv_eig_filter_1_' datatag '_3sphere'],...
            ['lcmv_eig_filter_2_' datatag '_3sphere'],...
            ['lcmv_reg_eig_' datatag '_3sphere'],...
            };
        params.tag = '-aniso-radius';
        params.matched = false;
        
    case 'mismatched-paper-aniso-normal-variations'
        params.beamformer_configs = {...
            ['rmv_aniso_mult_0-10_c_20' datatag '_3sphere'],...
            ['rmv_aniso_mult_0-10_c_40' datatag '_3sphere'],...
            ['rmv_aniso_mult_0-10_c_60' datatag '_3sphere'],...
            ['rmv_aniso_mult_0-15_c_20' datatag '_3sphere'],...
            ['rmv_aniso_mult_0-15_c_40' datatag '_3sphere'],...
            ['rmv_aniso_mult_0-15_c_60' datatag '_3sphere'],...
            ['rmv_aniso_mult_0-20_c_20' datatag '_3sphere'],...
            ['rmv_aniso_mult_0-20_c_40' datatag '_3sphere'],...
            ['rmv_aniso_mult_0-20_c_60' datatag '_3sphere'],...
            };
        params.tag = '-aniso-normal-variations';
        params.matched = false;
    otherwise
        error('unknown group name: %s\n',name);
end
        