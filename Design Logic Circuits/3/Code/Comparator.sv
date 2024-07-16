`timescale 1ns/1ns
module comparator_1b(input a,b, output e,g,l);
 wire w1,w2,w3;

 xor x1(w1,a,b);
 not n1(e,w1);

 not n2(w2,b);
 and a1(g,a,w2);

 or o1(w3,e,g);
 not n3(l,w3);
 
endmodule

module comparator_1b_c(input eq,gr, input a,b, output e,g,l);
 wire w1,w2,w3;
 wire w4,w5;

 comparator_1b comp1(a,b,w1,w2,w3);

 and a1(e,eq,w1);

 and a2(w4,eq,w2);
 or o1(g,w4,gr); 

 or o2(w5,e,g);
 not n1(l,w5);
 
endmodule

module comparator_4b(input[3:0] a,b, output e,g,l);
 wire [0:11] w;

 comparator_1b_c comp1(1'b1,1'b0,a[3],b[3],w[0],w[1],w[2]);
 comparator_1b_c comp2(w[0],w[1],a[2],b[2],w[3],w[4],w[5]);
 comparator_1b_c comp3(w[3],w[4],a[1],b[1],w[6],w[7],w[8]);
 comparator_1b_c comp4(w[6],w[7],a[0],b[0],e,g,l);
 
endmodule

