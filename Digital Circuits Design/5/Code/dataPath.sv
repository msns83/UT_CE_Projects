module data_path(c_en,clk,reset,reg_en,rom_in,c5,mean);
 parameter n = 32 ;
 parameter logValue = $clog2(n) ;
 
 input c_en,clk,reset,reg_en;
 input [7:0] rom_in [0:n-1];
 output c5;
 output [7:0] mean; 

 wire [logValue:0] count;
 wire [logValue-1:0] index ;
 wire [12:0] last,reg_in ;

 reg [7:0] ROM [0:n-1];
 assign ROM = rom_in;

 assign index = count[logValue-1:0] ;

 counter #(logValue) c1(clk,c_en,reset,count);
 register r1 (clk,reg_en,reset,reg_in,last);

 assign reg_in = ROM[index]+last ;
 assign mean = last / n ;
 assign c5 = count[logValue];


endmodule
