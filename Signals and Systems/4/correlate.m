function result = correlate(a,b,frequency,bit_rate)

if size(a,1)>size(a,2)
    a = a';
end

if size(b,1)>size(b,2)
    b=b';
end

n = min(length(a),length(b));
a = a(1,1:n);
b = b(1,1:n);

result = a*(b')/double(frequency);
result = result * 2 * (2^bit_rate-1);

end