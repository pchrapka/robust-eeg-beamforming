% data_in = load(['output\sim_data_bem_1_100t\single_cort_src_1'...
%     '\0_1_rmv_aniso_eig_pre_0_3sphere_mini.mat']);
% 
% % Extract the beamformer data
% bf_data = data_in.source.beamformer_output;


data_in = load(...
    ['output\sim_data_bem_1_100t\single_cort_src_1'...
     '\0_1_rmv_aniso_eig_pre_0_3sphere_mini.mat']);
beam_out = data_in.source.beamformer_output;
plot_src_idx = 295;%1:501;
% plot_src_idx = 295;
figure;
for j=1:3
    for i=plot_src_idx
        comp(i,:) = squeeze(beam_out(j,i,:));
    end
    subplot(3,1,j);
    surf(comp);
    view(0, 0);
end
subplot(3,1,1);
title(['Index: ' num2str(plot_src_idx)]);

figure;
loc_idx = 295;
time_idx_length = size(beam_out,3);
for t=1:time_idx_length
    mag_out(t,1) = norm(beam_out(:,loc_idx,t));
end
% tit
plot(mag_out)
% 
% figure;
% surf();

% Calculate the power of the data
bf_power = squeeze(sqrt(sum(beam_out.^2,1)));
figure;
surf(bf_power);