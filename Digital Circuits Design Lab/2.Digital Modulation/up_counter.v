module up_counter #(parameter WIDTH) (clk, rst, count, cout);

    input clk, rst;
    output reg [WIDTH-1:0] count;
    output reg cout;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= {WIDTH{1'b0}};
            cout <= 1'b0;
        end else begin
            if (count == {{(WIDTH-1){1'b1}},1'b0} ) begin
                cout <= 1'b1;
		count <= count + 1;
            end else begin
                count <= count + 1;
                cout <= 1'b0;
            end
        end
    end

endmodule