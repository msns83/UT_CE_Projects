`timescale 1ns/1ns
module mux4_1bit(input w0, w1, w2, w3, input [1:0] s, output out);

 assign out = s[1] ? (s[0] ? w3 : w2) : (s[0] ? w1 : w0);

endmodule

module mux4(input[7:0] w0, w1, w2, w3, input [1:0] s, output[7:0] out);
 genvar i;
   generate
     for(i = 0; i < 8; i=i+1) begin: mux_stack
        mux4_1bit xx(w0[i],w1[i],w2[i],w3[i],s,out[i]);
     end
   endgenerate
endmodule