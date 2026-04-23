module fetch_instruction (input wire clk, rst,
                          input wire [31:0] mux_inp_BA, 
                          output wire [31:0] updated_pc, memory_in,
                          input wire branch_tacken, freeze);
    
    wire [31:0] mux_out;

    assign mux_out = ~branch_tacken ? updated_pc : mux_inp_BA;

    reg [31:0] PC;

    always @(posedge clk, posedge rst) begin
        if (rst) PC <= 0;
        else if (~freeze) PC <= mux_out;
    end

    assign updated_pc = PC + 1;

    assign memory_in = PC;

endmodule
