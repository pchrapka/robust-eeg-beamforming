function out = fix_label(in)

pattern = ['(?<type>rmv_aniso|rmv|lcmv_inv|lcmv)_*'...
    '(?<eig>eig_pre_cov|eig_post|eig_pre_leadfield|eig_cov|eig_filter|eig_leadfield)*_*'...
    '(?<int>(?(eig)\d+|))_*'...
    '(?<reg>reg_eig)*_*'...
    '(?<eps>epsilon)*_*'...
    '(?<epsilon>(?(eps)[\d-e]+|))_*'];
results = regexp(in,pattern,'names');

fields = {'type','eig','int','reg','eps'};
out = [];
for i=1:length(fields)
    field = fields{i};
    switch field
        case 'type'
            switch results.type
                case 'lcmv'
                    out = 'MVB';
                case 'lcmv_inv'
                    out = 'MVB inv';
                case 'rmv'
                    out = 'RMVB';
                case 'rmv_aniso'
                    out = 'RMVB anisotropic';
                otherwise
                    error('unknown beamformer type');
            end
        case 'eig'
            if ~isempty(results.eig)
                temp = strrep(results.eig,'_',' ');
                out = [out ' ' temp];
            end
        case 'int'
            if ~isempty(results.int)
                temp = str2num(results.int) + 1;
                out = [out ', Q=' sprintf('%d',temp)];
            end
        case 'reg'
            if ~isempty(results.reg)
                out = [out ' regularized'];
            end
        case 'eps'
            if ~isempty(results.eps)
                temp = strrep(results.epsilon,'-','.');
                temp = strrep(temp,'e.','e-');
                out = [out ', \epsilon = ' temp];
            end
    end
    
end

% switch in
%     case 'rmv_epsilon_20'
%         out = 'RMVB, isotropic \epsilon = 20';
%         %case 'rmv_epsilon_50'
%     case 'rmv_eig_pre_cov_0_epsilon_20'
%         out = 'RMVB eig pre cov, Q=1, \epsilon = 20';
%     case 'rmv_eig_post_0_epsilon_20'
%         out = 'RMVB eig post, Q=1, \epsilon = 20';
%         %case 'rmv_eig_post_0_epsilon_50'
%     case 'lcmv'
%         out = 'MVB';
%     case 'lcmv_eig_0'
%         out = 'Eigenspace-based MVB, Q=1';
%     case 'lcmv_eig_1'
%         out = 'Eigenspace-based MVB, Q=2';
%     case 'lcmv_reg_eig'
%         out = 'Regularized MVB';
%         %case 'rmv_epsilon_50_3sphere'
%     case 'rmv_epsilon_100_3sphere'
%         out = 'RMVB, isotropic \epsilon = 100';
%     case 'rmv_epsilon_150_3sphere'
%         out = 'RMVB, isotropic \epsilon = 150';
%     case 'rmv_epsilon_200_3sphere'
%         out = 'RMVB, isotropic \epsilon = 200';
%         %case 'rmv_epsilon_250_3sphere'
%         %case 'rmv_epsilon_300_3sphere'
%     case 'rmv_aniso_3sphere'
%         out = 'RMVB, anisotropic';
%     case 'rmv_eig_pre_cov_0_epsilon_150_3sphere'
%         out = 'RMVB eig pre cov, Q=1, \epsilon = 150';
%     case 'rmv_eig_pre_cov_0_epsilon_200_3sphere'
%         out = 'RMVB eig pre cov, Q=1, \epsilon = 200';
%         %case 'rmv_eig_post_0_epsilon_50_3sphere'
%         %case 'rmv_eig_post_0_epsilon_100_3sphere'
%     case 'rmv_eig_post_0_epsilon_150_3sphere'
%         out = 'RMVB eig post, Q=1, \epsilon = 150';
%     case 'rmv_eig_post_0_epsilon_200_3sphere'
%         out = 'RMVB eig post, Q=1, \epsilon = 200';
%         %case 'rmv_aniso_eig_0_3sphere'
%     case 'lcmv_3sphere'
%         out = 'MVB';
%     case 'lcmv_eig_0_3sphere'
%         out = 'Eigenspace-based MVB, Q=1';
%     case 'lcmv_eig_1_3sphere'
%         out = 'Eigenspace-based MVB, Q=2';
%     case 'lcmv_reg_eig_3sphere'
%         out = 'Regularized MVB';
%     otherwise
%         error(['reb:' mfilename],...
%             sprintf('unknown label %s\n', in));
% end

end