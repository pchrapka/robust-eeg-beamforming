function out = gauss_distr(x, mu, covariance)
% NOTE This is not a gaussian pdf
% Instead of using mvnpdf where the integral of the gaussian pdf is equal
% to 1, all I want is the strength of the signal to drop off with a
% gaussian shape.

out = 1;
n_comp = size(x,2);
% for i=1:n_comp
%     out = out*(1/sqrt(2*pi*covariance(i)))...
%         *exp(-(x(i) - mu(i))^2/(2*covariance(i)));
% end

for i=1:n_comp
    out = out*exp(-(x(i) - mu(i))^2/(2*covariance(i)));
end
end