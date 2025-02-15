module data_path(
    input clk,
    input rst,
    input pcen,
    input adrsrc,
    input memwrite,
    input irwrite,
    input regwrite,
    input [1:0]alusrca,
    input [1:0]alusrcb,
    input [2:0]aluop,
    input [1:0]resultsrc,
    input [2:0]immsrc,
    output neg,
    output zer,
    output [6:0]func7,
    output [2:0]func3,
    output [6:0]opcode
);

wire [31:0] resultdata;
wire [31:0] pcout;
wire [31:0] memadr;
wire [31:0] A, B;
wire [31:0] memmoryout;
wire [31:0] instruction;
wire [31:0] oldpc;
wire [31:0] memmorydataregister;
wire [31:0] extended_data;
wire [31:0] registeredA, registeredB;
wire [31:0] aluopranda, aluoprandb;
wire [31:0] aluresult;
wire [31:0] registeredaluresult;

PC pc(clk,rst,resultdata,pcen,pcout);
multiplexer_2to1 memadrselect(adrsrc,pcout,resultdata,memadr);
memory Memmory(memadr,B,clk,rst,memwrite,memmoryout);

register IR(clk,rst,memmoryout,irwrite,instruction);
register OLDPC(clk,rst,pcout,irwrite,oldpc);
register MDR(clk,rst,memmoryout,1'b1,memmorydataregister);

imm_extend IMM_EXTEND(instruction[31:7],immsrc,extended_data);

file_reg FILE_REG(clk,rst,instruction[19:15],instruction[24:20],instruction[11:7],resultdata,regwrite,A,B);
register a(clk,rst,A,1'b1,registeredA);
register b(clk,rst,B,1'b1,registeredB);

multiplexer_4to1 alusela(alusrca,pcout,oldpc,registeredA,32'b0,aluopranda);
multiplexer_4to1 aluselb(alusrcb,registeredB,extended_data,32'd4,32'b0,aluoprandb);

ALU alu(aluopranda,aluoprandb,aluop,aluresult,zer,neg);
register aluout(clk,rst,aluresult,1'b1,registeredaluresult);
multiplexer_4to1 resultselect(resultsrc,registeredaluresult,aluresult,memmorydataregister,extended_data,resultdata);

assign opcode = instruction[6:0];
assign func3 = instruction[14:12];
assign func7 = instruction[31:25];
endmodule