
close all;

ntrials = 100;
ntime = 100;
nchannels = 2;

f = 20;
fs = 250;
t = 0:(1/fs):(ntime-1)/fs;
type = 'sine';
% type = 'sine-time';
% type = 'var';
% type = 'sine-phase';

fprintf('signal type: %s\n',type);

%% generate signal
x = zeros(ntrials, nchannels, ntime);

switch type
    case 'sine'
        for i=1:ntrials
%             a = mvnrnd([2 4],0.1*eye(2));
            a = mvnrnd([1 1],0.1*eye(2));
            for k=1:nchannels
                x(i,k,:) = a(k)*sin(2*pi*f*t);
            end
        end
        
    case 'sine-time'
        ntrials = 1;
        x = zeros(ntrials,nchannels,ntime);
        a = mvnrnd([2 4], 0.1*eye(2),ntime);
        for i=1:ntime
            for k=1:nchannels
                x(1,k,i) = a(i,k);
            end
        end
        
    case 'sine-phase';
        for i=1:ntrials
            a = 1;
            phase(1) = mvnrnd(1/3*pi,0.1);
            phase(2) = mvnrnd(pi,0.1);
            for k=1:nchannels
                x(i,k,:) = a*sin(2*pi*f*t + repmat(phase(k),size(t)));
            end
        end
        
    case 'var'
        a(1) = 0.5;
        a(2) = -0.3;
        for i=1:ntrials
            for j=1:ntime
                u = mvnrnd(zeros(2,1),0.1*eye(2));
                if j == 1
                    for k=1:nchannels
                        x(i,k,j) = u(k);
                    end
                else
                    for k=1:nchannels
                        x(i,k,j) = a(k)*x(i,k,j-1) + u(k);
                    end
                end
            end
        end
end

for i=1:ntrials
    for k=1:nchannels
        figure(k);
        plot(t,squeeze(x(i,k,:)));
        hold on;
    end
end

%% plot average
x_avg = squeeze(mean(x,1));
figure;
plot(t,x_avg(1,:),t,x_avg(2,:));
legend('ch 1', 'ch 2');
title('average');

%% compute covariance from average
x_avg2 = (x_avg - repmat(mean(x_avg,2),1,ntime));
R_avg = x_avg2*x_avg2'/ntime;

%% compute covariance from samples across all trials
Rsum = zeros(nchannels);
for i=1:ntrials
    x_trial = squeeze(x(i,:,:));
    x_trial2 = x_trial - repmat(mean(x_trial,2),1,ntime);
    Rsum = Rsum + x_trial2*x_trial2';
end

R_trials = Rsum/(ntrials*ntime);

%% compute covariance over trials at each sample
R_time = zeros(ntime,nchannels,nchannels);
for i=1:ntime
    x_time = squeeze(x(:,:,i))';
    x_time2 = x_time - repmat(mean(x_time,2),1,ntrials);
    R_time(i,:,:) = x_time2*x_time2';
end

R_time = R_time/ntime;

%% singular values from all trials
[U,S,V] = svd(R_trials);
fprintf('singular values - all trials\n');
disp(S);

%% singular values from avg of trials
[U,S,V] = svd(R_avg);
fprintf('singular values - average of trials\n');
disp(S);


%% singular values from instantaneous covariance
idx_time = 4;
[U,S,V] = svd(squeeze(R_time(idx_time,:,:)));
fprintf('singular values - time %0.3f\n',t(idx_time));
disp(S);
