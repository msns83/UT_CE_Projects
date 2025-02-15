clear;close;clc;

msg = 'signal';

out_1bit = coding_amp(msg,1,100);
out_2bit = coding_amp(msg,2,100);
out_3bit = coding_amp(msg,3,100);


decoding_amp(out_1bit,1,100)
decoding_amp(out_2bit,2,100)
decoding_amp(out_3bit,3,100)


