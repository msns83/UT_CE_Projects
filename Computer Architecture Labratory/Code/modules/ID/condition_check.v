module condition_check (input wire [3:0] cond, input wire z, c, n, v, output wire ccoo);
    reg cco;
    always @(*) begin
        case (cond)
            4'd0: cco = z;
            4'd1: cco = ~z;
            4'd2: cco = c;
            4'd3: cco = ~c;
            4'd4: cco = n;
            4'd5: cco = ~n;
            4'd6: cco = v;
            4'd7: cco = ~v;
            4'd8: cco = c && ~z;
            4'd9: cco = ~(c && ~z);
            4'd10: cco = n == v;
            4'd11: cco = n != v;
            4'd12: cco = ~z && (n == v);
            4'd13: cco = ~(~z && (n == v));
            4'd14: cco = 1;
            4'd15: cco = 0; 
            default: cco = 0;
        endcase
    end
    assign ccoo = ~cco;
endmodule