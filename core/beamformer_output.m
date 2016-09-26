function beamformer_output(data_set, beamformers)

p = inputParser();
addRequired(p,'data_set',@(x) isa(x,'SimDataSetEEG'));
addRequired(p,'beamformers',@(x) ~isempty(x) && iscell(x));
parse(p,data_set,beamformers);

% determine covariance type
eeg_file = sprintf('%s.mat',data_set.get_full_filename);
dineeg = load(eeg_file);
if isfield(dineeg.data,'Rtime')
    cov_type = 'time';
    R = dineeg.data.Rtime;
elseif isfield(dineeg.data,'Rtrial')
    cov_type = 'trial';
else
    error('unknown covariance type');
end

for i=1:length(beamformers);
    % load beamformer data
    bf_file = sprintf('%s_%s.mat',data_set.get_full_filename,beamformers{i});
    din = load(bf_file);
    data = din.source;
    clear din;
    
    % get vars
    nscans = length(data.loc);
    ncomponents = 3;
    
    switch cov_type
        case 'trial'
            sample_idx = data.sample_idx;
            R = dineeg.data.Rtrial(sample_idx,:,:);
        case 'time'
            if isfield(data,'sample_idx')
                sample_idx = data.sample_idx;
            else
                sample_idx = 1:size(dineeg.data.avg_trials,2);
                warning('missing sample_idx in beamformer data file');
            end
    end
    
    % set up beamformer
    fbeamformer = str2func(data.beamformer_config{1});
    beamformer = fbeamformer(data.beamformer_config{2:end});
    
    % select sample points based on the sample_idx parameter
    data_trials = dineeg.data.avg_trials(:,sample_idx);
    
    % allocate mem
    beam_signal = zeros(nscans, length(sample_idx), ncomponents);
    
    %data_loc = data.loc;
    data_filter = data.filter;
    
    % compute the projection matrix
    if ~isequal(beamformer.eig_type,'none')
        P = beamformer.get_P(R);
    end
    
    %parfor j=1:nscans
    for j=1:nscans
        
        % get W
        W = data_filter{j};

        switch cov_type
            case 'time'
                beam_signal(j,:,:) = beamformer.output(...
                    W, data_trials, 'P', P)';
            case 'trial'
                beam_signal_temp = zeros(length(sample_idx),ncomponents);
                for k=1:length(sample_idx)
                    
                    beam_signal_temp(k,:) = beamformer.output(...
                        W, data_trials(:,k), 'P', P)';
                end
                beam_signal(j,:,:) = beam_signal_temp;
        end
    end
    
    source = data;
    source.sample_idx = sample_idx;
    % rearrange the output
    source.beamformer_output = permute(beam_signal, [3 1 2]); % [components vertices time]
    
    % save data
    save(bf_file, 'source','-v7.3');
    
end


end