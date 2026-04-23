module MUX (IN1, IN2, select, OUT);
    input IN1, IN2, select;
    output OUT;
    assign OUT = select ? IN2 : IN1;
endmodule