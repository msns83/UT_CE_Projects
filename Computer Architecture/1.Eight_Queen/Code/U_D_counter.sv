`timescale 1ns/1ns
module U_D_counter(en, up_down, a_rst, ld, Load, clk, out, cout);
    input en, up_down, clk, a_rst, ld;
    input[2:0] Load ;
    output[2:0] out; 
    output cout;
    reg[2:0] out;
    reg cout;

    always @(posedge clk or posedge a_rst)
    begin
        if(a_rst)
            {cout,out} = 4'b0000 ;
        else
        begin
            if(ld)
                out = Load ;
            else if(en)
                begin
                    if (up_down)
                        {cout,out} = out + 1'b1 ;
                    else if(~up_down)
                        {cout,out} = out - 1'b1 ;
                end
        end
    end
    
endmodule