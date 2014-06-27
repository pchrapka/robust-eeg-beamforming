function [rms_out, rms_col_labels] = rms_summarize(rms_data)

if length(rms_data) > 1
    % Summarize data for multiple beamformer configurations and potentially
    % multiple iterations
    
    % Check if we have multiple iterations
    if length(rms_data(1).iteration) > 1
        multiple_iters = true;
    end
    
    % Setup the columns
    if multiple_iters
        rms_col_labels = {...
            'Beamformer',...
            ...'Peak Index',...
            'Avg RMS Error',...
            'Var RMS Error',...
            'Avg RMS Input',...
            'Var RMS Input',...
            'Avg 20log(RMSE/RMS Input)'};
    else    
        rms_col_labels = {...
            'Beamformer',...
            ...'Peak Index',...
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
%             peak_index = fprintf('%d ', cur_data.true_peak_idx);
            
            k = 1;
            rms_out{k,i} = cur_data.name;
            k = k+1;
%             rms_out{k,i} = peak_index;
%             k = k+1;
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
%             rms_out{k,i} = cur_data.true_peak_idx;
%             k = k+1;
            rms_out{k,i} = cur_data.rmse;
            k = k+1;
            rms_out{k,i} = cur_data.rms_input;
            k = k+1;
            rms_out{k,i} = 20*log10(cur_data.rmse/cur_data.rms_input);
        end
    end
    
else
    % Summarize data for a single iteration
    rmse_2_rms_input = 20*log10(...
        rms_data.rmse./rms_data.rms_input);
    % Output the columns
    rms_col_labels = {'Beamformer', 'Peak Index', 'RMS Error',...
        'RMS Input', '20log(RMSE/RMS Input)'};
    rms_out = {};
    for i=1:size(rms_data.rmse,2)
        A = [rms_data.name;...
            num2cell(rms_data.true_peak_idx(:,i)');...
            num2cell(rms_data.rmse(:,i)');...
            num2cell(rms_data.rms_input(:,i)');...
            num2cell(rmse_2_rms_input(:,i)')];
        
        rms_out = [rms_out A];
    end
    
end

end