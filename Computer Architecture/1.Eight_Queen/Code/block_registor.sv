`timescale 1ns/1ns
module block_register(sel_read, sel_write, ld, Load, rst, clk, out);
    input[2:0] sel_read, sel_write;
    input ld, rst, clk;
    input[7:0] Load;
    output[7:0] out;
    reg[7:0] out;
    reg[7:0] block[7:0] ;
    integer i;

    always @(posedge clk or posedge rst)
    begin
        if(rst)
            for (i = 0; i < 8; i = i + 1)
                block[i] = 8'b00000000;
        else
        begin
            if(ld)
            begin
                case (sel_write)
                    3'b000: block[0] = Load;
                    3'b001: block[1] = Load;
                    3'b010: block[2] = Load;
                    3'b011: block[3] = Load;
                    3'b100: block[4] = Load;
                    3'b101: block[5] = Load;
                    3'b110: block[6] = Load;
                    3'b111: block[7] = Load;
                    default: block[6] = Load;
                endcase
            end
            
            case (sel_read)
                3'b000: out = block[0] ;
                3'b001: out = block[1] ;
                3'b010: out = block[2] ;
                3'b011: out = block[3] ;
                3'b100: out = block[4] ;
                3'b101: out = block[5] ;
                3'b110: out = block[6] ;
                3'b111: out = block[7] ;
                default: out = block[7];
            endcase   
        end
    end

endmodule