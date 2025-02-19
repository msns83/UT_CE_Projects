module shifterRL(input In,RL,Clk,Reset,En, output [7:0] Q);
 wire [7:0] filpIn ;

 mux2 m7(In,Q[6],RL,filpIn[7]);
 filpflop f7(filpIn[7],Clk,Reset,En,Q[7]);
 
 genvar i;
   generate
     for(i = 7; 1 < i; i=i-1) begin: pack_stack
        mux2 mm (Q[i],Q[i-2],RL,filpIn[i-1]);
        filpflop ff (filpIn[i-1], Clk, Reset,En, Q[i-1]) ;
     end
   endgenerate

 mux2 m0(Q[1],In,RL,filpIn[0]);
 filpflop f0(filpIn[0],Clk,Reset,En,Q[0]);

endmodule
