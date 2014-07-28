function [rms_out, rms_col_labels] = rms_summarize(rms_data)
%RMS_SUMMARIZE Summarize data for multiple beamformer configurations and
%potentially multiple iterations

multiple_iters = false;

% Check if we have multiple iterations
if length(rms_data(1).iteration) > 1
    multiple_iters = true;
end

% Setup the columns
if multiple_iters
    rms_col_labels = {...
        'Beamformer',...
        'Location Index',...
        'Sample Index',...
        'Avg RMS Error',...
        'Var RMS Error',...
        'Avg RMS Input',...
        'Var RMS Input',...
        'Avg 20log(RMSE/RMS Input)'};
else
    rms_col_labels = {...
        'Beamformer',...
        'Location Index',...
        'Sample Index',...
        'RMS Error',...
        'RMS Input',...
        '20log(RMSE/RMS Input)'};
end

n_cols = length(rms_data);
n_rows = length(rms_col_labels);
rms_out = cell(n_rows, n_cols);
for i=1:length(rms_data)
    cur_data = rms_data(i);
    if multiple_iters
        rmse_avg = mean(cur_data.rmse);
        rmse_var = var(cur_data.rmse);
        rms_input_avg = mean(cur_data.rms_input);
        rms_input_var = var(cur_data.rms_input);
        location_idx = fprintf('%d ', cur_data.location_idx);
        sample_idx = fprintf('%d ', cur_data.sample_idx);
        
        k = 1;
        rms_out{k,i} = cur_data.name;
        k = k+1;
        rms_out{k,i} = location_idx;
        k = k+1;
        rms_out{k,i} = sample_idx;
        k = k+1;
        rms_out{k,i} = rmse_avg;
        k = k+1;
        rms_out{k,i} = rmse_var;
        k = k+1;
        rms_out{k,i} = rms_input_avg;
        k = k+1;
        rms_out{k,i} = rms_input_var;
        k = k+1;
        rms_out{k,i} = 20*log10(rmse_avg/rms_input_avg);
    else
        k = 1;
        rms_out{k,i} = cur_data.name;
        k = k+1;
        rms_out{k,i} = cur_data.location_idx;
        k = k+1;
        rms_out{k,i} = cur_data.sample_idx;
        k = k+1;
        rms_out{k,i} = cur_data.rmse;
        k = k+1;
        rms_out{k,i} = cur_data.rms_input;
        k = k+1;
        rms_out{k,i} = 20*log10(cur_data.rmse/cur_data.rms_input);
    end
end


end