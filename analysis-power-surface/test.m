list = {'0_1_rmv_100_power3d','0_1_lcmv_power3d_','0_1_lcmv_eig_1_power3d'};
tf1 = strfind(list, 'lcmv_power3d');

tf2 = ~cellfun('isempty',strfind(list,'lcmv_power3d'));

matched = {'0_1_lcmv_power3d_s131.png'};
pattern = '(?<=s)\d+';
sample = regexp(matched{1}, pattern, 'match')