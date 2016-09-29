function theory_snr_type1(sim,source,vertex,varargin)

p = inputParser();
addRequired(p,'sim',@ischar);
addRequired(p,'source',@ischar);
addRequired(p,'BeamformerVertex',@isnumeric);
cov_options = {'theory','data','theory-signal'};
addParameter(p,'CovType','theory',@(x) any(validatestring(x,cov_options)));
addParameter(p,'snr',[],@isnumeric);
addParameter(p,'VarNoise',1,@isnumeric);
addParameter(p,'VarSignal',0,@isnumeric);
addParameter(p,'verbosity',0,@(x) x >= 0 && x < 2);
parse(p,sim,source,vertex,varargin{:});

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
    nchannels = size(f,1);
    
    switch p.Results.CovType
        case 'theory'
            var_signal = p.Results.VarSignal;
            var_noise = p.Results.VarNoise;
            
            R = var_signal*(f*f') + var_noise*eye(nchannels);
            cov_signals = 'signal+noise';
            
            power_signal = var_signal*norm(f)^2;
            power_noise = var_noise*nchannels;
            snr_data = power_signal/power_noise;
            snr_data2 = power_signal/var_noise;
        case 'theory-signal'
            var_signal = p.Results.VarSignal;
            var_noise = p.Results.VarNoise;
            
            R = var_signal*(f*f');
            cov_signals = 'signal';
            
            power_signal = var_signal*norm(f)^2;
            power_noise = var_noise*nchannels;
            snr_data = power_signal/power_noise;
            snr_data2 = power_signal/var_noise;
        case 'data'
            data_set = SimDataSetEEG(sim,cfg.source_name,p.Results.snr,'iter',1);
            data_file = data_set.get_full_filename();
            din = load(data_file);
            
            % compute power
            data_signal_power = trace(cov(din.data.avg_signal'));
            data_noise_power = trace(cov(din.data.avg_noise'));
            snr_data = data_signal_power/data_noise_power;
            snr_data2 = data_signal_power/(data_noise_power/nchannels);
            
            % compute source and noise variance
            var_noise = data_noise_power/nchannels;
            var_signal = data_signal_power/(norm(f)^2);
            power_avg_signal = var_signal*norm(f)^2/nchannels;
            if power_avg_signal < 2*var_noise
                warning('average source power is really close to the noise power');
                fprintf('average signal power:\n\t%f\n',power_avg_signal);
                fprintf('average noise power:\n\t%f\n',var_noise);
            end
            
            R = din.data.Rtime;
            cov_signals = 'signal+noise';
        otherwise
            error('unknown covariance type');
    end
    fprintf('Input SNR Ratio:\n\t%0.2f, %0.2f dB\n',snr_data,db(snr_data,'power'));
    fprintf('Input SNR Ratio 2:\n\t%0.2f, %0.2f dB\n',snr_data2,db(snr_data2,'power'));
    fprintf('Signal variance:\n\t%g\n',var_signal);
    fprintf('Noise variance:\n\t%g\n',var_noise);
    
    alpha = (var_signal/var_noise)*norm(f)^2;
    % source to noise ratio
    fprintf('Input Source to Noise Ratio:\n\t%0.2f, %0.2f dB\n',alpha,db(alpha,'power'));
    
    omega = alpha/(1+alpha);
    
    % get leadfield at beamforming vertex
    L = cfg.head.get_leadfield(p.Results.BeamformerVertex);
    
    % 
    [Z,D] = eig_sorted(L'*pinv(R)*L);
    
    % approximate version
    % p.92 of Sekihara eq 6.43
    l1_inv = norm(L*Z(:,1))^(-2);
    l2_inv = norm(L*Z(:,2))^(-2);
    l3_inv = norm(L*Z(:,3))^(-2);
    
    switch cov_signals
        case 'signal+noise'
            snr_approx = (l1_inv + l2_inv + l3_inv/(1-omega))/...
                (l1_inv + l2_inv + l3_inv*(1-(2*omega-omega^2))/(1-omega)^2);
            % Z = Z_0 + 1 
            % Z_0 in Sekihara
            snr0_approx = snr_approx - 1;
        case 'signal'
            if rank(R) == 1
                %snr_approx = (l1_inv/(1-omega) + l2_inv + l3_inv)/...
                %    (l1_inv*(1-(2*omega-omega^2))/(1-omega)^2 + l2_inv + l3_inv);
                num = alpha*(1+omega^2-2*omega)*l1_inv;
                den = (1-2*omega+omega^2)*l1_inv + l2_inv*(1-omega)^2 + l3_inv*(1-omega)^2;
                snr_approx = num/den;
            else
                error('check l_inv''s');
            end
            % Z = Z_0
            % Z_0 in Sekihara
            snr0_approx = snr_approx;
    end
    
    fprintf('Output SNR approx:\n\t%0.2f, %0.2f dB\n',snr0_approx,db(snr0_approx,'power'));
    fprintf('SNR factor:\n\t%f\n',snr0_approx/alpha);
    
    % exact version
    switch cov_signals
        case 'signal+noise'
            num = zeros(3,1);
            den = zeros(3,1);
            for i=1:3
                cos_term = gen_cosine(Z(:,i),eta,L'*L)^2;
                if p.Results.verbosity > 0
                    fprintf('\tCos term %d: %g\n',i,cos_term);
                end
                l_norm = norm(L*Z(:,i))^2;
                
                num(i) = var_noise*(l_norm * (1-omega*cos_term))^(-1);
                
                temp_num = 1-(2*omega-omega^2)*cos_term;
                temp_den = l_norm * (1-omega*cos_term)^2;
                den(i) = var_noise*temp_num/temp_den;
                if p.Results.verbosity > 0
                    fprintf('\tNum: %g\n',num(i));
                    fprintf('\tDen: %g\n',den(i));
                end
            end
            snr_exact = sum(num)/sum(den);
            output_signal_power = sum(num) - sum(den);
            output_noise_power = sum(den);
            %snr_exact = output_signal_power/output_noise_power;
            
            snr0_exact = snr_exact - 1; % Z_0 in Sekihara
        case 'signal'
            num = zeros(3,1);
            den = zeros(3,1);
            beta = (var_signal/(var_noise^2))*(1+alpha^2/(1+alpha)^2-2*alpha/(1+alpha));
            for i=1:3
                cos_term = gen_cosine(Z(:,i),eta,L'*L)^2;
                if p.Results.verbosity > 0
                    fprintf('\tCos term %d: %g\n',i,cos_term);
                end
                if abs(cos_term) < eps
                    cos_term = 0;
                end
                l_norm = norm(L*Z(:,i))^2;
                
                temp_num = (var_noise^2)*(norm(f)^2)*cos_term;
                temp_den = l_norm * (1-omega*cos_term)^2;
                num(i) = beta*temp_num/temp_den;
                
                temp_num = 1-(2*omega-omega^2)*cos_term;
                temp_den = l_norm * (1-omega*cos_term)^2;
                den(i) = var_noise*temp_num/temp_den;
                if p.Results.verbosity > 0
                    fprintf('\tNum: %g\n',num(i));
                    fprintf('\tDen: %g\n',den(i));
                end
            end
            output_signal_power = sum(num);
            output_noise_power = sum(den);
            snr_exact = output_signal_power/output_noise_power;
            %snr_exact = sum(num)/sum(den);
            
            snr0_exact = snr_exact; % Z_0 in Sekihara
    end
    
    fprintf('Output SNR exact:\n\t%0.2f, %0.2f dB\n',snr0_exact,db(snr0_exact,'power'));
    fprintf('SNR factor:\n\t%f\n',snr0_exact/alpha);
    fprintf('Output Power - signal: %g noise %g\n',...
                output_signal_power,output_noise_power);
    
    if isequal(p.Results.CovType,'data')
        fprintf('noise power\n');
        Rn_data = cov(din.data.avg_noise');
        Rn_theory = var_noise*eye(nchannels);
        Rn_data_diag = diag(diag(Rn_data));
        fprintf('\tdata: %g, size: %g\n', trace(Rn_data),norm(Rn_data,'fro'));
        fprintf('\ttheory: %g, size: %g\n', trace(Rn_theory),norm(Rn_theory,'fro'));
        Rs = cov(din.data.avg_signal');
        %R = Rs + Rn_theory;
        %R = Rs + Rn_data_diag;
        %R = Rs + Rn_data;
        Rinv = pinv(R);
        W = Rinv*L*pinv(L'*Rinv*L);
        
        channel_norm = 1;
        
        output_signal_power = trace(W'*cov(din.data.avg_trials')*W);
        output_noise_power = trace(W'*cov(din.data.avg_noise')*W)/channel_norm;
        snr_data_output = output_signal_power/output_noise_power;
        fprintf('Data Output Trials 2 Noise Ratio:\n\t%0.2f, %0.2f dB\n',...
            snr_data_output,db(snr_data_output,'power'));
        fprintf('Output Power - signal: %g noise %g\n',...
            output_signal_power,output_noise_power);
        
        output_signal_power = trace(W'*cov(din.data.avg_signal')*W);
        output_noise_power = trace(W'*cov(din.data.avg_noise')*W)/channel_norm;
        snr_data_output = output_signal_power/output_noise_power;
        fprintf('Data Output SNR 1:\n\t%0.2f, %0.2f dB\n',...
            snr_data_output,db(snr_data_output,'power'));
        fprintf('Output Power - signal: %g noise %g\n',...
            output_signal_power,output_noise_power);
        
        output_signal = W'*din.data.avg_signal;
        output_signal_power = trace(output_signal*output_signal');
        output_noise = W'*din.data.avg_noise;
        output_noise_power = trace(output_noise*output_noise')/channel_norm;
        snr_data_output = output_signal_power/output_noise_power;
        fprintf('Data Output SNR 2:\n\t%0.2f, %0.2f dB\n',...
            snr_data_output,db(snr_data_output,'power'));
        fprintf('Output Power - signal: %g noise %g\n',...
            output_signal_power,output_noise_power);
        
        % optimal direction is smallest evector of L'*Rinv*L
        eta_opt = Z(:,3);
        w_opt = W*eta_opt;
        output_signal_power = w_opt'*cov(din.data.avg_signal')*w_opt;
        output_noise_power = w_opt'*cov(din.data.avg_noise')*w_opt/channel_norm;
        snr_data_output = output_signal_power/output_noise_power;
        fprintf('Data Output SNR Type 2:\n\t%0.2f, %0.2f dB\n',...
            snr_data_output,db(snr_data_output,'power'));
        fprintf('Output Power - signal: %g noise %g\n',...
            output_signal_power,output_noise_power);
        
        output_signal_power = trace(W'*cov(din.data.avg_signal')*W);
        output_noise_power = trace(W'*Rn_theory*W)/channel_norm;
        snr_data_output = output_signal_power/output_noise_power;
        fprintf('Data Output SNR white noise:\n\t%0.2f, %0.2f dB\n',...
            snr_data_output,db(snr_data_output,'power'));
        fprintf('Output Power - signal: %g noise %g\n',...
            output_signal_power,output_noise_power);
        
        output_signal_power = trace(W'*cov(din.data.avg_signal')*W);
        output_noise_power = trace(W'*diag(diag(Rn_data))*W)/channel_norm;
        snr_data_output = output_signal_power/output_noise_power;
        fprintf('Data Output SNR data diag\n\t%0.2f, %0.2f dB\n',...
            snr_data_output,db(snr_data_output,'power'));
        fprintf('Output Power - signal: %g noise %g\n',...
            output_signal_power,output_noise_power);
    end
    
    if p.Results.verbosity > 0
        fprintf('diff z3 and eta:\n\t%f\n',norm(Z(:,3)-eta));
    end
    
    if p.Results.verbosity > 0
        fprintf('Orthogonality of Z''s and eta\n');
        for i=1:3
            fprintf('\t%d: %f\n',i,Z(:,i)'*eta);
        end
    end
end

end