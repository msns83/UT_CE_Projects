module multiplier_4b(
    input  wire [3:0] a,
    input  wire [3:0] b,
    output wire [7:0] p
);

    wire p00,p01,p02,p03;
    wire p10,p11,p12,p13;
    wire p20,p21,p22,p23;
    wire p30,p31,p32,p33;

    and_1b g00(.A1(a[0]), .B1(b[0]), .out(p00));
    and_1b g01(.A1(a[1]), .B1(b[0]), .out(p01));
    and_1b g02(.A1(a[2]), .B1(b[0]), .out(p02));
    and_1b g03(.A1(a[3]), .B1(b[0]), .out(p03));

    and_1b g10(.A1(a[0]), .B1(b[1]), .out(p10));
    and_1b g11(.A1(a[1]), .B1(b[1]), .out(p11));
    and_1b g12(.A1(a[2]), .B1(b[1]), .out(p12));
    and_1b g13(.A1(a[3]), .B1(b[1]), .out(p13));

    and_1b g20(.A1(a[0]), .B1(b[2]), .out(p20));
    and_1b g21(.A1(a[1]), .B1(b[2]), .out(p21));
    and_1b g22(.A1(a[2]), .B1(b[2]), .out(p22));
    and_1b g23(.A1(a[3]), .B1(b[2]), .out(p23));

    and_1b g30(.A1(a[0]), .B1(b[3]), .out(p30));
    and_1b g31(.A1(a[1]), .B1(b[3]), .out(p31));
    and_1b g32(.A1(a[2]), .B1(b[3]), .out(p32));
    and_1b g33(.A1(a[3]), .B1(b[3]), .out(p33));

    assign p[0] = p00;

    wire s11, c11;
    half_adder_1b ha11 (.a(p01), .b(p10), .s(s11), .cn(c11));
    assign p[1] = s11;

    wire s21, c21, s22, c22;
    full_adder_1b fa21 (.a(p02), .b(p11), .c(c11), .s(s21), .cn(c21));
    half_adder_1b ha22 (.a(p20), .b(s21), .s(s22), .cn(c22));
    assign p[2] = s22;

    wire s23, c23, s31, c31, s32, c32;
    full_adder_1b fa23 (.a(p03), .b(p12), .c(c21), .s(s23), .cn(c23));
    full_adder_1b fa31 (.a(p21), .b(s23), .c(c22), .s(s31), .cn(c31));
    half_adder_1b ha32 (.a(p30), .b(s31), .s(s32), .cn(c32));
    assign p[3] = s32;

    wire s41, c41, s42, c42, s43, c43;
    full_adder_1b fa41 (.a(p22), .b(p13), .c(c23), .s(s41), .cn(c41));
    full_adder_1b fa42 (.a(p31), .b(s41), .c(c31), .s(s42), .cn(c42));
    half_adder_1b ha43 (.a(s42), .b(c32), .s(s43), .cn(c43));
    assign p[4] = s43;

    wire s51, c51, s52, c52;
    full_adder_1b fa51 (.a(p23), .b(c41), .c(c42), .s(s51), .cn(c51));
    full_adder_1b fa52 (.a(p32), .b(s51), .c(c43), .s(s52), .cn(c52));
    assign p[5] = s52;

    wire s61, c61;
    full_adder_1b fa61 (.a(p33), .b(c51), .c(c52), .s(s61), .cn(c61));
    assign p[6] = s61;

    assign p[7] = c61;

endmodule