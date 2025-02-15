module MUX8 (IN2, select, OUT);
    input [7:0] IN2;
	 input select;
    output [7:0] OUT;
    assign OUT = select ? IN2 : 8'b10000000;
endmodule