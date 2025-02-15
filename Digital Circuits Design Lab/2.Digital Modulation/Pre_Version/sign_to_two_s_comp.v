module sign_to_two_s_comp (Sign_bit, magnitude_in, magnitude_out);
input Sign_bit;
input [7:0] magnitude_in;
output reg [7:0] magnitude_out;
reg dont_care;
always @(*) begin
    magnitude_out = Sign_bit ? (~magnitude_in+1) : magnitude_in;
end
endmodule