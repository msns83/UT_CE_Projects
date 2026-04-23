`timescale 1ns/1ns

module top_TB;
    reg Clock = 0;
    reg Reset = 1;
    reg Start = 0;

    wire Ready;
    wire [15:0] Result;

    reg [7:0] A0, A1, W0, W1;
    reg [15:0] D_Result;

    integer pass_count = 0;
    integer fail_count = 0;
    integer tc = 0;

    top dut(
        .Clock(Clock),
        .Reset(Reset),
        .Start(Start),
        .A0(A0), .A1(A1), .W0(W0), .W1(W1),
        .Ready(Ready),
        .Result(Result)
    );

    initial begin
        Clock = 1'b0;
        forever #1 Clock = ~Clock;
    end

    task check;
        begin
            tc = tc + 1;
            if (Result !== D_Result) begin
                fail_count = fail_count + 1;
                $display("FAIL tc=%0d A0=%b W0=%b A1=%b W1=%b exp=%b got=%b",
                         tc, A0, W0, A1, W1, D_Result, Result);
            end else begin
                pass_count = pass_count + 1;
            end
        end
    endtask

    initial begin
        // init
        A0 = 0; A1 = 0; W0 = 0; W1 = 0;
        D_Result = 0;
        Start = 0;

        // reset
        #4 Reset = 0;
        #2;

        // tc1
        A0 = 8'b00100010; W0 = 8'b01110010; A1 = 8'b00011001; W1 = 8'b01100010; D_Result = 16'b0001100010110110;
        Start = 1; #2 Start = 0; #30; check();

        // tc2
        A0 = 8'b10010010; W0 = 8'b00101010; A1 = 8'b00001110; W1 = 8'b00000000; D_Result = 16'b0001011111110100;
        Start = 1; #2 Start = 0; #30; check();

        // tc3
        A0 = 8'b01101001; W0 = 8'b00000000; A1 = 8'b01001100; W1 = 8'b00111111; D_Result = 16'b0001001010110100;
        Start = 1; #2 Start = 0; #30; check();

        // tc4
        A0 = 8'b00000000; W0 = 8'b01111111; A1 = 8'b00011001; W1 = 8'b01010111; D_Result = 16'b0000100001111111;
        Start = 1; #2 Start = 0; #30; check();

        // tc5
        A0 = 8'b11110101; W0 = 8'b00010011; A1 = 8'b00000000; W1 = 8'b00101101; D_Result = 16'b0001001000101111;
        Start = 1; #2 Start = 0; #30; check();

        // tc6
        A0 = 8'b11111111; W0 = 8'b01001100; A1 = 8'b00000001; W1 = 8'b00101101; D_Result = 16'b0100101111100001;
        Start = 1; #2 Start = 0; #30; check();

        // tc7
        A0 = 8'b00000001; W0 = 8'b00100000; A1 = 8'b11111111; W1 = 8'b01011001; D_Result = 16'b0101100011000111;
        Start = 1; #2 Start = 0; #30; check();

        // tc8
        A0 = 8'b00000000; W0 = 8'b00000000; A1 = 8'b00000000; W1 = 8'b00000000; D_Result = 16'b0000000000000000;
        Start = 1; #2 Start = 0; #30; check();

        // tc9
        A0 = 8'b11111111; W0 = 8'b11111111; A1 = 8'b00000101; W1 = 8'b00000010; D_Result = 16'b1111111000001011;
        Start = 1; #2 Start = 0; #30; check();

        // tc10
        A0 = 8'b11111111; W0 = 8'b11111111; A1 = 8'b11111111; W1 = 8'b00000010; D_Result = 16'b1111111111111111;
        Start = 1; #2 Start = 0; #30; check();

        // tc11
        A0 = 8'b10000000; W0 = 8'b10000000; A1 = 8'b10000000; W1 = 8'b10000000; D_Result = 16'b1000000000000000;
        Start = 1; #2 Start = 0; #30; check();

        // tc12
        A0 = 8'b11111111; W0 = 8'b10000000; A1 = 8'b01111111; W1 = 8'b00000001; D_Result = 16'b0111111111111111;
        Start = 1; #2 Start = 0; #30; check();

        // tc13
        A0 = 8'b11111111; W0 = 8'b10000000; A1 = 8'b10000001; W1 = 8'b00000001; D_Result = 16'b1000000000000001;
        Start = 1; #2 Start = 0; #30; check();

        // tc14
        A0 = 8'b10101010; W0 = 8'b01010101; A1 = 8'b01010101; W1 = 8'b10101010; D_Result = 16'b0111000011100100;
        Start = 1; #2 Start = 0; #30; check();

        // tc15
        A0 = 8'b00000001; W0 = 8'b00000001; A1 = 8'b00000000; W1 = 8'b00000000; D_Result = 16'b0000000000000001;
        Start = 1; #2 Start = 0; #30; check();

        // tc16
        A0 = 8'b11111111; W0 = 8'b00000000; A1 = 8'b00000000; W1 = 8'b11111111; D_Result = 16'b0000000000000000;
        Start = 1; #2 Start = 0; #30; check();

        // tc17
        A0 = 8'b11001000; W0 = 8'b01111011; A1 = 8'b01100100; W1 = 8'b11001000; D_Result = 16'b1010111000111000;
        Start = 1; #2 Start = 0; #30; check();

        // tc18
        A0 = 8'b01001001; W0 = 8'b11010011; A1 = 8'b00010011; W1 = 8'b11101001; D_Result = 16'b0100110101110110;
        Start = 1; #2 Start = 0; #30; check();

        // tc19
        A0 = 8'b11111111; W0 = 8'b11111111; A1 = 8'b11111111; W1 = 8'b00000001; D_Result = 16'b1111111100000000;
        Start = 1; #2 Start = 0; #30; check();

        // tc20
        A0 = 8'b11111111; W0 = 8'b01100100; A1 = 8'b11111111; W1 = 8'b01100100; D_Result = 16'b1100011100111000;
        Start = 1; #2 Start = 0; #30; check();

        // tc21
        A0 = 8'b00000101; W0 = 8'b11111111; A1 = 8'b11111111; W1 = 8'b00000101; D_Result = 16'b0000100111110110;
        Start = 1; #2 Start = 0; #30; check();

        $display("SUMMARY: total=%0d pass=%0d fail=%0d", tc, pass_count, fail_count);
        $stop;
    end

endmodule