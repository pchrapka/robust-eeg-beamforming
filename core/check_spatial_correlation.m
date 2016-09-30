function check_spatial_correlation(sim,source)

p = inputParser();
addRequired(p,'sim',@ischar);
addRequired(p,'source',@ischar);
%addRequired(p,'BeamformerVertex',@isnumeric);
%cov_options = {'theory','data','theory-signal'};
%addParameter(p,'CovType','theory',@(x) any(validatestring(x,cov_options)));
%addParameter(p,'snr',[],@isnumeric);
%addParameter(p,'VarNoise',1,@isnumeric);
%addParameter(p,'VarSignal',0,@isnumeric);
%addParameter(p,'verbosity',0,@(x) x >= 0 && x < 2);
parse(p,sim,source);

warning('on','all');

% Load the simulation parameters
eval(sim);
eval(source);

cfg = sim_cfg;

nsources = length(cfg.sources);
if nsources == 1
    error('does not apply for one source');
else
    spatial_cor = zeros(nsources);
    for i=1:nsources
        H1 = cfg.head.get_leadfield(cfg.sources{i}.source_index);
        eta1 = cfg.sources{i}.moment;
        
        nchannels = size(H1,1);
        
        for j=i:nsources
            H2 = cfg.head.get_leadfield(cfg.sources{j}.source_index);
            eta2 = cfg.sources{j}.moment;
            
            spatial_cor(i,j) = gen_cosine(H1*eta1,H2*eta2,eye(nchannels));
        end
    end
    
    fprintf('spatial correlation\n');
    disp(spatial_cor);
end



end