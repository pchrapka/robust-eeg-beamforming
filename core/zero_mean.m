function output = zero_mean(signal)
nsamples = size(signal,2);
signal_mean = mean(signal,2);
output = signal - repmat(signal_mean,1,nsamples);
end