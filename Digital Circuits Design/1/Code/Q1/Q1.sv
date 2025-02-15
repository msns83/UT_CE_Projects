`timescale 1ns/1ns
module fibo1(input [3:0] in, output out);
 wire [3:0] inverted;
 wire w1,w2,w3;

 genvar i;
 generate
  for (i = 0; i < 4; i = i + 1) begin : inverter
   not #(1) input_not (inverted[i], in[i]);
  end
 endgenerate

 and #(2) G1(w1,inverted[3],inverted[2]);
 and #(2) G2(w2,in[2],inverted[1],in[0]);
 and #(2) G3(w3,inverted[2],inverted[1],inverted[0]);

 or #(3) G4(out,w1,w2,w3);
endmodule
