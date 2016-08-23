function out = fix_label(in)

switch in
    case 'rmv_epsilon_20'
        out = 'RMVB, isotropic \epsilon = 20';
        %case 'rmv_epsilon_50'
        %case 'rmv_eig_post_0_epsilon_20'
        %case 'rmv_eig_post_0_epsilon_50'
    case 'lcmv'
        out = 'MVB';
    case 'lcmv_eig_0'
        out = 'Eigenspace-based MVB, Q=1';
    case 'lcmv_eig_1'
        out = 'Eigenspace-based MVB, Q=2';
    case 'lcmv_reg_eig'
        out = 'Regularized MVB';
        %case 'rmv_epsilon_50_3sphere'
    case 'rmv_epsilon_100_3sphere'
        out = 'RMVB, isotropic \epsilon = 100';
    case 'rmv_epsilon_150_3sphere'
        out = 'RMVB, isotropic \epsilon = 150';
    case 'rmv_epsilon_200_3sphere'
        out = 'RMVB, isotropic \epsilon = 200';
        %case 'rmv_epsilon_250_3sphere'
        %case 'rmv_epsilon_300_3sphere'
    case 'rmv_aniso_3sphere'
        out = 'RMVB, anisotropic';
        %case 'rmv_eig_post_0_epsilon_50_3sphere'
        %case 'rmv_eig_post_0_epsilon_100_3sphere'
        %.case 'rmv_eig_post_0_epsilon_150_3sphere'
        %case 'rmv_eig_post_0_epsilon_200_3sphere'
        %case 'rmv_aniso_eig_0_3sphere'
    case 'lcmv_3sphere'
        out = 'MVB';
    case 'lcmv_eig_0_3sphere'
        out = 'Eigenspace-based MVB, Q=1';
    case 'lcmv_eig_1_3sphere'
        out = 'Eigenspace-based MVB, Q=2';
    case 'lcmv_reg_eig_3sphere'
        out = 'Regularized MVB';
    otherwise
        error(['reb:' mfilename],...
            sprintf('unknown label %s\n', in));
end

end