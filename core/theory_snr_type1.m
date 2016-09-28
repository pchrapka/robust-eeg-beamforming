function theory_snr_type1(sim,source,snr,vertex)

p = inputParser();
addRequired(p,'sim',@ischar);
addRequired(p,'source',@ischar);
addRequired(p,'snr',@isnumeric);
addRequired(p,'BeamformerVertex',@isnumeric);
% addParameter(p,'VarNoise',1,@isnumeric);
% addParameter(p,'VarSignal',1,@isnumeric);
parse(p,sim,source,snr,vertex);

warning('on','all');

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
    snr_data = data_signal_power/data_noise_power;
    fprintf('Input SNR Ratio:\n\t%0.2f, %0.2f dB\n',snr_data,db(snr_data,'power'));
    
    nchannels = size(din.data.avg_signal,1);
    % compute source and noise variance
    var_noise = data_noise_power/nchannels;
    var_signal = data_signal_power/(norm(f)^2);
    power_avg_signal = var_signal*norm(f)^2/nchannels;
    if power_avg_signal < 2*var_noise
        warning('average source power is really close to the noise power');
        fprintf('average signal power:\n\t%f\n',power_avg_signal);
        fprintf('average noise power:\n\t%f\n',var_noise);
    end
    
    alpha = var_signal/var_noise*norm(f)^2;
    % source to noise ratio
    fprintf('Input Source to Noise Ratio:\n\t%0.2f, %0.2f dB\n',alpha,db(alpha,'power'));
    
    omega = alpha/(1+alpha);
    
    % get leadfield at beamforming vertex
    L = cfg.head.get_leadfield(p.Results.BeamformerVertex);
    %cov_type = 'data';
    cov_type = 'theoretical';
    switch cov_type
        case 'data'
            R = din.data.Rtime;
        case 'theoretical'
            R = var_signal*norm(f)^2;
    end
    
    % TODO double check output
    [Z,D] = eig_sorted(L'*pinv(R)*L);
    
    % approximate version
    % p.92 of Sekihara eq 6.43
    l1_inv = norm(L*Z(:,1))^(-2);
    l2_inv = norm(L*Z(:,2))^(-2);
    l3_inv = norm(L*Z(:,3))^(-2);
    
    snr_approx = var_noise*(l1_inv + l2_inv + l3_inv/(1-omega))/...
        (l1_inv + l2_inv + l3_inv*(1-(2*omega-omega^2))/(1-omega)^2);
    
    fprintf('Output SNR approx:\n\t%0.2f, %0.2f dB\n',snr_approx,db(snr_approx,'power'));
    fprintf('SNR factor:\n\t%f\n',(snr_approx-1)/alpha);
    
    % exact version
    num = zeros(3,1);
    den = zeros(3,1);
    for i=1:3
        cos_term = gen_cosine(Z(:,i),eta,L'*L)^2;
        fprintf('\tCos term %d: %g\n',i,cos_term);
        l_norm = norm(L*Z(:,i))^2;
        
        num(i) = var_noise*(l_norm * (1-omega*cos_term))^(-1);
        
        temp_num = 1-(2*omega-omega^2)*cos_term;
        temp_den = l_norm * (1-omega*cos_term)^2;
        den(i) = temp_num/temp_den;
        fprintf('\tNum: %g\n',num(i));
        fprintf('\tDen: %g\n',den(i));
    end
    snr_exact = sum(num)/sum(den);
    
    fprintf('Output SNR exact:\n\t%0.2f, %0.2f dB\n',snr_exact,db(snr_exact,'power'));
    fprintf('SNR factor:\n\t%f\n',(snr_exact-1)/alpha);
    
    fprintf('diff z3 and eta:\n\t%f\n',norm(Z(:,3)-eta));
    
    fprintf('Orthogonality of Z''s and eta\n');
    for i=1:3
        fprintf('\t%d: %f\n',i,Z(:,i)'*eta);
    end
end

end