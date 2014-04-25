function out = get_data_files(cfg)
% Returns data file based on cfg
% cfg
%   data_name
%   source_name
%   snr_range
%   iteration_range

count = 1;
out = cell(1,length(cfg.snr_range)*length(cfg.iteration_range));
for i=1:length(cfg.snr_range)
    for j=1:length(cfg.iteration_range)
        tmpcfg = [];
        tmpcfg.sim_name = cfg.data_name;
        tmpcfg.source_name = cfg.source_name;
        tmpcfg.snr = cfg.snr_range(i);
        tmpcfg.iteration = cfg.iteration_range(j);
        out{count} = db.get_full_file_name(tmpcfg);    
        count = count + 1;
    end
end

if length(out) == 1
    out{count} = 'dummy';
end
end