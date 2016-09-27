function theory_snr_type1(sim,source,snr,vertex)

p = inputParser();
addRequired(p,'sim',@ischar);
addRequired(p,'source',@ischar);
addRequired(p,'snr',@isnumeric);
addRequired(p,'BeamformerVertex',@isnumeric);
% addParameter(p,'VarNoise',1,@isnumeric);
% addParameter(p,'VarSignal',1,@isnumeric);
parse(p,sim,source,snr,vertex);

% Load the simulation parameters
eval(sim);
eval(source);

cfg = sim_cfg;

% var_noise = 1;

nsources = length(cfg.sources);
if nsources > 1
    error('does not apply for more than one source');
else
    H = cfg.head.get_leadfield(cfg.sources{1}.source_index);
    eta = cfg.sources{1}.moment;
    
    f = H*eta;
    
    data_set = SimDataSetEEG(sim,cfg.source_name,snr,'iter',1);
    data_file = data_set.get_full_filename();
    din = load(data_file);
    
    % compute power
    data_signal_power = trace(cov(din.data.avg_signal'));
    data_noise_power = trace(cov(din.data.avg_noise'));
    
    nchannels = size(din.data.avg_signal,1);
    % compute source and noise variance
    var_noise = data_noise_power/nchannels;
    var_signal = data_signal_power/(norm(f)^2);
    
    alpha = var_signal/var_noise*norm(f)^2;
    % source to noise ratio
    fprintf('Input Source to Noise Ratio:\n\t%0.2f, %0.2f dB\n',alpha,db(alpha,'power'));
    
    omega = alpha/(1+alpha);
    
    % get leadfield at beamforming vertex
    L = cfg.head.get_leadfield(p.Results.BeamformerVertex);
    R = din.data.Rtime;
    
    % TODO double check output
    [Z,D] = eig_sorted(L'*pinv(R)*L);
    
    % approximate version
    % p.92 of Sekihara
    l1_inv = norm(L*Z(:,1))^(-2);
    l2_inv = norm(L*Z(:,2))^(-2);
    l3_inv = norm(L*Z(:,3))^(-2);
    
    snr_approx = var_noise*(l1_inv + l2_inv + l3_inv/(1-omega))/...
        (l1_inv + l2_inv + l3_inv*(1-(2*omega-omega^2))/(1-omega)^2);
    
    fprintf('Output SNR approx:\n\t%0.2f, %0.2f dB\n',snr_approx,db(snr_approx,'power'));
    fprintf('SNR factor:\n\t%f\n',(snr_approx-1)/alpha);
    
    % exact version
    num = 0;
    den = 0;
    for i=1:3
        cos_term = gen_cosine(Z(:,i),eta,L'*L);
        l_norm = norm(L*Z(:,i))^2;
        
        temp = l_norm * (1-omega*cos_term^2);
        num = num + temp^(-1);
        
        temp_den = l_norm * (1-omega*cos_term^2)^2;
        temp_num = 1-(2*omega-omega^2)*cos_term^2;
        den = den + temp_num/temp_den;
    end
    snr_exact = var_noise*num/den;
    
    fprintf('Output SNR exact:\n\t%0.2f, %0.2f dB\n',snr_exact,db(snr_exact,'power'));
    fprintf('SNR factor:\n\t%f\n',(snr_exact-1)/alpha);
    
    fprintf('diff z3 and eta:\n\t%f\n',norm(Z(:,3)-eta));
end

end