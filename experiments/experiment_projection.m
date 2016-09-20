%% projection matrices

clear all

n = 10;
A = rand(10);

R = A*A';

[V,D] = eig(R);

cfg = [];
cfg.R = R;
cfg.n_interfering_sources = 2;
P = aet_analysis_eig_projection(cfg);

%% check if the projector is projecting
fprintf('P*V\n');
disp(P*V)

fprintf('last 3 columns of V\n');
disp(V(:,end-2:end))
fprintf('the previous 2 should be equal\n');

fprintf('------------\n');

%% 
fprintf('R^-1 * P\n');
RinvP = pinv(R)*P;
disp(RinvP);

fprintf('P * R^-1\n');
PRinv = P*pinv(R);
disp(PRinv);

fprintf('(P*R)^-1\n');
PRbothinv = pinv(P*R);
disp(PRbothinv);

fprintf('(R*P)^-1\n');
RPbothinv = pinv(R*P);
disp(RPbothinv);