module D_Reg (
    input wire clk, rst,
    input wire [3:0] D_en,
    input wire and_out, xor_out,

    output reg [3:0] D
);
    always @(posedge clk or posedge rst) begin
        if(rst)
            D <= 4'b0000 ;
        else if(|D_en) begin
            case (D_en) 
                4'b0001: D[0] <= and_out ;
                4'b0010: D[1] <= xor_out ;
                4'b1100: begin
                    D[2] <= xor_out ; 
                    D[3] <= and_out ;
                end
                default: ;
            endcase 
        end
    end
endmodule

module X_Reg (
    input wire clk, rst,
    input wire [3:0] X_en,
    input wire and_out,

    output reg [3:0] X
);
    always @(posedge clk or posedge rst) begin
        if(rst)
            X <= 4'b0000 ;
        else if(|X_en) begin
            case (X_en) 
                4'b0010: X[1] <= and_out ;
                4'b0100: X[2] <= and_out ;
                4'b1000: X[3] <= and_out ; 
                default: ;
            endcase 
        end
    end
endmodule


module Val_Reg (
    input wire clk, rst,
    input wire [3:0] reg_en,
    input wire xor_out,

    output reg [3:0] reg_val
);
    always @(posedge clk or posedge rst) begin
        if(rst)
            reg_val <= 4'b0000 ;
        else if(|reg_en) begin
            case (reg_en) 
                4'b0001: reg_val[0] <= xor_out ;
                4'b0010: reg_val[1] <= xor_out ;
                4'b0100: reg_val[2] <= xor_out ;
                4'b1000: reg_val[3] <= xor_out ; 
                default: ;
            endcase 
        end
    end
endmodule

module C_Reg (
    input wire clk, rst,
    input wire [3:0] C_en,
    input wire and_out, funct_out,

    output reg [3:0] C
);
    always @(posedge clk or posedge rst) begin
        if(rst)
            C <= 4'b0000 ;
        else if(|C_en) begin
            case (C_en) 
                4'b0010: C[1] <= and_out ;
                4'b0100: C[2] <= funct_out ;
                4'b1000: C[3] <= funct_out ; 
                default: ;
            endcase 
        end
    end
endmodule


module CM_Reg (
    input wire clk, rst,
    input wire [3:0] CM_en,
    input wire and_out,

    output reg [3:0] CM
);
    always @(posedge clk or posedge rst) begin
        if(rst)
            CM <= 1'b0 ;
        else if(CM_en)
            CM <= and_out ; 
    end
endmodule