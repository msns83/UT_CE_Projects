function result = correlate_coeff(a,b)
a = double(a);
b = double(b);
result = (sum(a.*b,'all'))/sqrt(sum(a.*a,'all')*sum(b.*b,'all'));
end