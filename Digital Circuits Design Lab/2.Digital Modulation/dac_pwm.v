module dac_pwm (clk, rst, pwm_in, pwm_out);
    input wire clk;
    input wire rst;
    input wire [7:0] pwm_in;
    output reg pwm_out;
    localparam integer PERIOD = 256;

    reg [7:0] counter;       // Counter to generate PWM

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 8'd0;
        end else begin
            counter <= counter + 8'd1;
        end
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            pwm_out <= 1'b0;
        end else begin
            pwm_out <= (counter < pwm_in) ? 1'b1 : 1'b0;
        end
    end

endmodule
