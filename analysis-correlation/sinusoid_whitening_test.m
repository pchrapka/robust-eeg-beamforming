% Test out whitening of two sinusoids
close all;

n_samples = 500;
fs = 250;
t = (0:n_samples-1)/fs;

% Generate sinusoids
f = 10;
amplitude = 1;
sigma = amplitude/10;
s1 = amplitude*sin(2*pi*f*t);% + sigma*randn(1,n_samples);

phase = pi/2;
s2 = amplitude*sin(2*pi*f*t+phase);% + sigma*randn(1,n_samples);

% Calculate the correlation
c = xcorr(s1, s2, 0, 'coeff');

sources = [s1; s2];

% Plot the original sources
figure;
subplot(2,1,1);
plot(t,sources(1,:),t,sources(2,:));
title(sprintf('Original signals, cor: %f', c));

% Whiten
R = cov(sources');
L = chol(R);

sources_whitened = L\sources;

c = xcorr(sources_whitened(1,:), sources_whitened(2,:), 0, 'coeff');

% Plot the whitened sources
subplot(2,1,2);
plot(t,sources_whitened(1,:),t,sources_whitened(2,:));
title(sprintf('Whitened signals, cor: %f', c));