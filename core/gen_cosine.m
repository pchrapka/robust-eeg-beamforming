function out = gen_cosine(a1,a2,D)

num = abs(a1'*D*a2);

c1 = a1'*D*a1;
c2 = a2'*D*a2;
den = sqrt(c1*c2);
out = num/den;

end