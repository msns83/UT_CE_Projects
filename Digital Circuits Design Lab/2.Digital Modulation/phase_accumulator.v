module phase_accumulator(clk, rst, sign, phase, addr);

    input clk, rst;
    output reg sign, phase ;
    output [5:0] addr;

    parameter [1:0] A = 2'b00, B = 2'b01 , C = 2'b10 , D = 2'b11;
    reg [1:0] ps, ns ;

    wire [5:0] count ;
    wire cout ;

    up_counter #6 UC1(clk, rst, count, cout);
    assign addr = count;

    always @(posedge clk, posedge rst) begin
        if (rst)
            ps <= A;
        else ps <= ns;
    end

    always @(ps, cout) begin
			ns = A;
        case(ps)
            A: ns = cout ? B : A ;
            B: ns = cout ? C : B ;
            C: ns = cout ? D : C ;
            D: ns = cout ? A : D ;
        endcase
    end

    always @(ps) begin
			{sign,phase} = 2'b00;
        case(ps)
            A: {sign,phase} = 2'b00;
            B: {sign,phase} = 2'b01;
            C: {sign,phase} = 2'b10;
            D: {sign,phase} = 2'b11;
        endcase
    end

endmodule