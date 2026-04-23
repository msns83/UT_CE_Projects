module TOP(
    input wire clk,
    input wire rst,
    input wire [1:0] in1, in2,

    output wire done
);
    wire [3:0] D_en, C_en, X_en, reg_en;
    wire [3:0] cycle_num ;
    wire CM_en ;

    DataPath datapath(
        .clk(clk), .rst(rst),
        .in1(in1), .in2(in2), .D_en(D_en), .X_en(X_en),
        .C_en(C_en), .reg_en(reg_en), .CM_en(CM_en), .cycle_num(cycle_num)
    );

    Controller controller(
        .clk(clk), .rst(rst), .D_en(D_en), .X_en(X_en),
        .C_en(C_en), .reg_en(reg_en), .CM_en(CM_en), .cycle_num(cycle_num), .done(done)
    );

endmodule