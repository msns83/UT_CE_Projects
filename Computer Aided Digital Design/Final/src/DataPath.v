module DataPath(
    input wire clk, rst,
    input wire [1:0] in1, in2,
    input wire [3:0] D_en, X_en, C_en, reg_en,
    input wire CM_en,
    input wire [3:0] cycle_num
);
    wire [2:0] and_in, xor_in, funct_in ;
    wire and_out, xor_out, funct_out ;
    wire [3:0] D, X, C, reg_val;
    wire CM;

    AND_mux and_mux (.in1(in1), .in2(in2), .D0(D[0]), .reg_val0(reg_val[0]), .X1(X[1]), .X2(X[2]), .X3(X[3]), .CM1(CM), .cycle_num(cycle_num), .LUT_A_in1(and_in[0]), .LUT_A_in2(and_in[1]));
    assign and_in[2] = 1'b1 ;
    LUT_A and_lut(.in(and_in), .out(and_out));


    XOR_mux xor_mux (.D0(D[0]), .D1(D[1]), .D2(D[2]), .D3(D[3]), .reg_val0(reg_val[0]), .reg_val1(reg_val[1]), .reg_val2(reg_val[2]), .reg_val3(reg_val[3]), .X1(X[1]), .X2(X[2]), .X3(X[3]), .C1(C[1]), .C2(C[2]), .C3(C[3]), .CM1(CM), .cycle_num(cycle_num), .LUT_X_in1(xor_in[0]), .LUT_X_in2(xor_in[1]), .LUT_X_in3(xor_in[2]));
    LUT_X xor_lut(.in(xor_in), .out(xor_out));


    F_mux funct_mux(.D1(D[1]), .D2(D[2]), .reg_val1(reg_val[1]), .reg_val2(reg_val[2]), .C1(C[1]) , .C2(C[2]), .cycle_num(cycle_num), .LUT_F_in1(funct_in[0]), .LUT_F_in2(funct_in[1]), .LUT_F_in3(funct_in[2]));
    LUT_F funct(.in(funct_in), .out(funct_out));


    D_Reg d_reg(.clk(clk), .rst(rst), .D_en(D_en), .and_out(and_out), .xor_out(xor_out), .D(D));
    X_Reg x_reg(.clk(clk), .rst(rst), .X_en(X_en), .and_out(and_out), .X(X));
    Val_Reg val_reg(.clk(clk), .rst(rst), .reg_en(reg_en), .xor_out(xor_out), .reg_val(reg_val));
    C_Reg c_reg(.clk(clk), .rst(rst), .C_en(C_en), .and_out(and_out), .funct_out(funct_out), .C(C));
    CM_Reg cm_reg(.clk(clk), .rst(rst), .CM_en(CM_en), .and_out(and_out), .CM(CM));
endmodule