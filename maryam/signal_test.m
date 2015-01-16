clc;
close all;
clear all;

frames = 400;
epochs = 1;
srate = 250;
wave = false;

sources{1}.amp = 1;
sources{1}.freq = 10;
sources{1}.pos = 120;
sources{1}.jitter = 5;

sources{2}.amp = -1;
sources{2}.freq = 4;
sources{2}.pos = 120;
sources{2}.jitter = 5;

for i=1:length(sources)
    signal{i} = sources{i}.amp * pr_peak(...
        frames, epochs, srate,...
        sources{i}.freq, sources{i}.pos, sources{i}.jitter, wave);
end

figure;
plot(1:frames, signal{1}, 1:frames, signal{2});

sig_cov = cov(signal{1}, signal{2});
disp('cov = ');
disp(sig_cov);

[sig_xcorr,lags] = xcorr(signal{1}, signal{2});
% disp('xcorr = ');
% disp(sig_xcorr);
figure;
plot(lags,sig_xcorr);