% Visual test of rms calculation
close all;

%% Single location source
n = 100;
n_mid = floor(n/2);

% Simulate an input signal box
input = zeros(n,1);
input(n_mid,:) = 1;

% Simulate an output signal box that is longer than the input
bf_out = zeros(n,1);
bf_out(n_mid,:) = 2;
noise = randn(size(bf_out));
mask = not(bf_out > 0);
bf_out = -1*bf_out + mask.*noise;

[rmse, rms_input, alpha] = rms.rms_error(bf_out, input);
figure;
plot(1:n, input, 1:n, bf_out, 1:n, bf_out*alpha);
legend('input','bf out','bf out norm');
title('Single location source');

%% Multiple location source
n = 100;
n_mid = floor(n/2);
n_pad = 3;

% Simulate an input signal box
input = zeros(n,1);
idx_start = n_mid - n_pad;
idx_end = n_mid + n_pad;
input(idx_start:idx_end,:) = 1;

% Simulate an output signal box that is longer than the input
bf_out = input*2;
noise = randn(size(bf_out));
bf_out = bf_out + noise;

[rmse, rms_input, alpha] = rms.rms_error(bf_out, input);
figure;
plot(1:n, input, 1:n, bf_out, 1:n, bf_out*alpha);
legend('input','bf out','bf out norm');
title('Multiple location source');

%% Multiple location source, dipole moment, equal moment
comp = 3;
n = 100;
n_mid = floor(n/2);
n_pad = 3;

% Simulate an input signal box
input = zeros(n,comp);
idx_start = n_mid - n_pad;
idx_end = n_mid + n_pad;
input(idx_start:idx_end,:) = 1;

% Simulate an output signal box that is longer than the input
bf_out = input*2;
noise = randn(size(bf_out));
bf_out = bf_out + noise;

[rmse, rms_input, alpha] = rms.rms_error(bf_out, input);
figure;
for i=1:comp
    subplot(3,1,i);
    plot(1:n, input(:,i), 1:n, bf_out(:,i), 1:n, bf_out(:,i)*alpha);
    legend('input','bf out','bf out norm');
    if i==1
        title('Multiple location source, dipole moment, equal');
    end
end

%% Multiple location source, dipole moment, unequal moment
comp = 3;
noise_std = 0.1;
n = 100;
n_mid = floor(n/2);
n_pad = 3;

% Simulate an input signal box
input = zeros(n,comp);
idx_start = n_mid - n_pad;
idx_end = n_mid + n_pad;
moment = [3 2 1]/norm([3 2 1]);
for i=1:comp
    input(idx_start:idx_end,i) = moment(i);
end

% Simulate an output signal box that is longer than the input
bf_out = -1*input*2;
noise = randn(size(bf_out));
bf_out = bf_out + noise_std.*noise;

[rmse, rms_input, alpha] = rms.rms_error(bf_out, input);
figure;
for i=1:comp
    subplot(3,1,i);
    plot(1:n, input(:,i), 1:n, bf_out(:,i), 1:n, bf_out(:,i)*alpha);
    legend('input','bf out','bf out norm');
    if i==1
        title('Multiple location source, dipole moment, unequal');
    end
end