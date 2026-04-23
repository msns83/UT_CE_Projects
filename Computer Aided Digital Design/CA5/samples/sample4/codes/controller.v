module controller(
  input clk, rst, start,
  output reg op_ready,
  output reg [3:0] alu1_sel1, alu1_sel2,
  output reg alu1_op,
  output reg [3:0] mul1_sel1, mul1_sel2,
  output reg mul1_op,
  output reg [3:0] log1_sel1, log1_sel2,
  output reg [1:0] log1_op,
  output reg done_next, result_en,
  output reg reg_alu2_en, reg_mul4_en, reg_alu5_en, reg_log6_en, reg_mul7_en, reg_alu8_en
);

reg [4:0] state, next_state;
localparam S_IDLE = 0, S_DONE = 31;
localparam SCH_CYCLE_1 = 1;
localparam SCH_CYCLE_2 = 2;
localparam SCH_CYCLE_3 = 3;

always @(posedge clk or posedge rst) begin
  if (rst) state <= S_IDLE;
  else state <= next_state;
end

always @(*) begin
  op_ready = 0; next_state = state; done_next = 0; result_en = 0;
  reg_alu2_en = 0;
  reg_mul4_en = 0;
  reg_alu5_en = 0;
  reg_log6_en = 0;
  reg_mul7_en = 0;
  reg_alu8_en = 0;
  alu1_sel1 = 0; alu1_sel2 = 0; alu1_op = 0;
  mul1_sel1 = 0; mul1_sel2 = 0; mul1_op = 0;
  log1_sel1 = 0; log1_sel2 = 0; log1_op = 0;

  case (state)
    S_IDLE: begin
      op_ready = 1;
      if (start) next_state = SCH_CYCLE_1;
    end
    SCH_CYCLE_1: begin
      alu1_op = 0;
      alu1_sel1 = 0;
      alu1_sel2 = 1;
      reg_alu2_en = 1;
      mul1_op = 0;
      mul1_sel1 = 0;
      mul1_sel2 = 2;
      reg_mul4_en = 1;
      log1_op = 0;
      log1_sel1 = 1;
      log1_sel2 = 2;
      reg_log6_en = 1;
      next_state = SCH_CYCLE_2;
    end
    SCH_CYCLE_2: begin
      alu1_op = 1;
      alu1_sel1 = 3;
      alu1_sel2 = 4;
      reg_alu5_en = 1;
      mul1_op = 0;
      mul1_sel1 = 6;
      mul1_sel2 = 0;
      reg_mul7_en = 1;
      next_state = SCH_CYCLE_3;
    end
    SCH_CYCLE_3: begin
      alu1_op = 0;
      alu1_sel1 = 5;
      alu1_sel2 = 7;
      reg_alu8_en = 1;
      next_state = S_DONE;
    end
    S_DONE: begin
      result_en = 1;
      done_next = 1;
      next_state = S_IDLE;
    end
  endcase
end
endmodule