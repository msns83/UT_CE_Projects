module OnePulser (
    input clk,
    input rst,
    input LP,
    output reg SP
);
    parameter [2:0] A = 2'b00,
                    B = 2'b01,
                    C = 2'b10;
    reg [1:0] ps, ns;

    always @(ps, LP) begin
        ns = A;
        case (ps)
            A:          ns = LP ? B : A;
            B:          ns = C;
            C:          ns = LP ? C : A;
            default:    ns = A;
        endcase
    end

    always @(ps) begin
        SP = 1'b0;
        case (ps)
            B: SP = 1'b1;
            default: SP = 1'b0;
        endcase
    end

    always @(posedge clk, posedge rst) begin
        if (rst)
            ps <= A;
        else
            ps <= ns;
    end

endmodule