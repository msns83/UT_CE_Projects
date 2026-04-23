import ast
import sys
import json
from pathlib import Path
from src.dfg_creator import GraphBuilder, OperatorNode, IdentifierNode
from src.graph_visualizer import expression_to_graph, visualize_graph, visualize_scheduled_graph
from src.scheduler import MinLatencyScheduler, MinResourceScheduler, ScheduledNodeInfo

MinResourceAlgorithm = "MinResourceLatencyConstrained"
MinlatencyAlgorithm = "MinLatencyResourceContrained"

def load_input(filename: str) -> dict:
    with open(filename, "r") as file:
        return json.load(file)

def build_dfg(expression: str, folder_path : str):
    ast_root = expression_to_graph(expression)

    dot = visualize_graph(ast_root)
    dot.attr(label="", labelloc='t', fontsize='17')  
    dot.render(folder_path + "/pics/DFG", format='png', view=False, cleanup=True)

    builder = GraphBuilder()
    return builder.build(ast_root)


def schedule_dfg(dfg_root, algorithm : str, config : dict, folder_path : str) -> list:
    if (algorithm == MinResourceAlgorithm):
        scheduler = MinResourceScheduler(dfg_root=dfg_root, numof_resources=config["Resources"], max_time=config["MaxTime"])
    else:
        scheduler = MinLatencyScheduler(dfg_root=dfg_root, numof_resources=config["Resources"])    
    scheduler.schedule()
    schedule_info = scheduler.get_scheduling_info()

    dot = visualize_scheduled_graph(root_id=dfg_root.id, schedule_info=schedule_info)
    dot.attr(label="", labelloc='t', fontsize='17')  
    dot.render(folder_path + "/pics/ScheduledDFG", format='png', view=False, cleanup=True)

    return schedule_info

class VerilogGenerator:
    def __init__(self, schedule_info: list[ScheduledNodeInfo]):
        self.schedule_info = schedule_info
        self.nodes = {info.node.id: info for info in schedule_info}
        self.max_time = max(info.scheduled_time for info in schedule_info)
        
        self.inputs = set()
        for info in schedule_info:
            for op in info.node.operands:
                if isinstance(op, IdentifierNode):
                    self.inputs.add(op.name)
        self.inputs = sorted(list(self.inputs))
        
        self.signal_map = {name: i for i, name in enumerate(self.inputs)}
        self.reg_start_idx = len(self.inputs)
        
        for info in schedule_info:
            reg_name = f"reg_{info.node.op_type.lower()}{info.node.id}"
            self.signal_map[info.node.id] = len(self.signal_map)

        self.resources = {"ALU": 0, "MUL": 0, "LOG": 0}
        for info in schedule_info:
            r_type = info.node.op_type
            r_num = info.resource_num
            self.resources[r_type] = max(self.resources[r_type], r_num)

    def generate_datapath(self) -> str:
        lines = []
        lines.append("module datapath(")
        lines.append("  input clk, rst,\n")
        
        for inp in self.inputs:
            lines.append(f"  input [31:0] {inp},")
        
        lines.append("")
            
        for r_type, count in self.resources.items():
            for i in range(1, count + 1):
                lines.append(f"  input [3:0] {r_type.lower()}{i}_sel1,")
                lines.append(f"  input [3:0] {r_type.lower()}{i}_sel2,")
                if r_type == "LOG":
                    lines.append(f"  input [1:0] {r_type.lower()}{i}_op,")
                else:
                    lines.append(f"  input {r_type.lower()}{i}_op,")
            lines.append("")
                    
        lines.append("  input done_next,")
        lines.append("  input result_en,\n")
        
        for info in self.schedule_info:
            lines.append(f"  input reg_{info.node.op_type.lower()}{info.node.id}_en,")
        lines.append("")
            
        lines.append("  output reg [31:0] result,")
        lines.append("  output reg done")
        lines.append(");")
        lines.append("")
        
        for r_type, count in self.resources.items():
            for i in range(1, count + 1):
                prefix = f"{r_type.lower()}{i}"
                lines.append(f"wire [31:0] {prefix}_out;")
                lines.append(f"wire [31:0] {prefix}_op1, {prefix}_op2;")
                lines.append("")
                
        
        for info in self.schedule_info:
            reg_name = f"reg_{info.node.op_type.lower()}{info.node.id}"
            lines.append(f"reg [31:0] {reg_name};")
            
        lines.append("")
        
        for r_type, count in self.resources.items():
            for i in range(1, count + 1):
                prefix = f"{r_type.lower()}{i}"
                
                lines.append(f"reg [31:0] {prefix}_op1_reg;")
                lines.append("always @(*) begin")
                lines.append(f"  case ({prefix}_sel1)")
                for name, idx in self.signal_map.items():
                    if isinstance(name, str): 
                        lines.append(f"    4'd{idx}: {prefix}_op1_reg = {name};")
                    else: 
                        node_info = self.nodes[name]
                        reg_name = f"reg_{node_info.node.op_type.lower()}{node_info.node.id}"
                        lines.append(f"    4'd{idx}: {prefix}_op1_reg = {reg_name};")
                lines.append(f"    default: {prefix}_op1_reg = 0;")
                lines.append("  endcase")
                lines.append("end")
                lines.append(f"assign {prefix}_op1 = {prefix}_op1_reg;\n")
                
                lines.append(f"reg [31:0] {prefix}_op2_reg;")
                lines.append("always @(*) begin")
                lines.append(f"  case ({prefix}_sel2)")
                for name, idx in self.signal_map.items():
                    if isinstance(name, str):
                        lines.append(f"    4'd{idx}: {prefix}_op2_reg = {name};")
                    else:
                        node_info = self.nodes[name]
                        reg_name = f"reg_{node_info.node.op_type.lower()}{node_info.node.id}"
                        lines.append(f"    4'd{idx}: {prefix}_op2_reg = {reg_name};")
                lines.append(f"    default: {prefix}_op2_reg = 0;")
                lines.append("  endcase")
                lines.append("end")
                lines.append(f"assign {prefix}_op2 = {prefix}_op2_reg;")
                lines.append("")

        for r_type, count in self.resources.items():
            for i in range(1, count + 1):
                prefix = f"{r_type.lower()}{i}"
                if r_type == "ALU":
                    lines.append(f"assign {prefix}_out = ({prefix}_op) ? ({prefix}_op1 - {prefix}_op2) : ({prefix}_op1 + {prefix}_op2);")
                elif r_type == "MUL":
                    lines.append(f"assign {prefix}_out = ({prefix}_op) ? ({prefix}_op1 / {prefix}_op2) : ({prefix}_op1 * {prefix}_op2);")
                elif r_type == "LOG":
                    lines.append(f"assign {prefix}_out = ({prefix}_op == 2'b00) ? ({prefix}_op1 & {prefix}_op2) : (({prefix}_op == 2'b01) ? ({prefix}_op1 | {prefix}_op2) : ({prefix}_op1 ^ {prefix}_op2));")
        
        lines.append("")
        
        lines.append("always @(posedge clk or posedge rst) begin")
        lines.append("  if (rst) begin")
        for info in self.schedule_info:
            reg_name = f"reg_{info.node.op_type.lower()}{info.node.id}"
            lines.append(f"    {reg_name} <= 0;")
        lines.append("    result <= 0;")
        lines.append("    done <= 0;")
        lines.append("  end else begin")
        
        for info in self.schedule_info:
            reg_name = f"reg_{info.node.op_type.lower()}{info.node.id}"
            r_type = info.node.op_type.lower()
            r_num = info.resource_num
            lines.append(f"    if ({reg_name}_en) {reg_name} <= {r_type}{r_num}_out;")
            
        lines.append("    if (result_en) begin")
        last_node = self.schedule_info[-1]
        
        all_operands = set()
        for info in self.schedule_info:
            for op in info.node.operands:
                if isinstance(op, OperatorNode):
                    all_operands.add(op.id)
        
        root_node = None
        for info in self.schedule_info:
            if info.node.id not in all_operands:
                root_node = info.node
                break
        
        if root_node:
             lines.append(f"      result <= reg_{root_node.op_type.lower()}{root_node.id};")
        
        lines.append("    end")
        lines.append("    if (done_next) done <= 1;")
        lines.append("  end")
        lines.append("end")
        lines.append("endmodule")
        
        return "\n".join(lines)

    def generate_controller(self) -> str:
        lines = []
        lines.append("module controller(")
        lines.append("  input clk, rst, start,")
        lines.append("  output reg op_ready,")
        
        
        for r_type, count in self.resources.items():
            for i in range(1, count + 1):
                lines.append(f"  output reg [3:0] {r_type.lower()}{i}_sel1, {r_type.lower()}{i}_sel2,")
                if r_type == "LOG":
                    lines.append(f"  output reg [1:0] {r_type.lower()}{i}_op,")
                else:
                    lines.append(f"  output reg {r_type.lower()}{i}_op,")
                    
        lines.append("  output reg done_next, result_en,")
        
        reg_enables = []
        for info in self.schedule_info:
            reg_enables.append(f"reg_{info.node.op_type.lower()}{info.node.id}_en")
        lines.append(f"  output reg {', '.join(reg_enables)}")
        lines.append(");")
        lines.append("")
        
        lines.append("reg [4:0] state, next_state;") 
        lines.append("localparam S_IDLE = 0, S_DONE = 31;") 
        for t in range(1, self.max_time + 1):
            lines.append(f"localparam SCH_CYCLE_{t} = {t};")
            
        lines.append("")
        lines.append("always @(posedge clk or posedge rst) begin")
        lines.append("  if (rst) state <= S_IDLE;")
        lines.append("  else state <= next_state;")
        lines.append("end")
        lines.append("")
        
        lines.append("always @(*) begin")
        lines.append("  op_ready = 0; next_state = state; done_next = 0; result_en = 0;")
        for en in reg_enables: lines.append(f"  {en} = 0;")
        for r_type, count in self.resources.items():
            for i in range(1, count + 1):
                lines.append(f"  {r_type.lower()}{i}_sel1 = 0; {r_type.lower()}{i}_sel2 = 0; {r_type.lower()}{i}_op = 0;")
                
        lines.append("")
        lines.append("  case (state)")
        lines.append("    S_IDLE: begin")
        lines.append("      op_ready = 1;")
        lines.append("      if (start) next_state = SCH_CYCLE_1;")
        lines.append("    end")
        
        for t in range(1, self.max_time + 1):
            lines.append(f"    SCH_CYCLE_{t}: begin")
            
            nodes_at_t = [info for info in self.schedule_info if info.scheduled_time == t]
            
            for info in nodes_at_t:
                r_type = info.node.op_type.lower()
                r_num = info.resource_num
                
                op_val = 0
                if isinstance(info.node.op, ast.Sub): op_val = 1
                elif isinstance(info.node.op, (ast.Div, ast.Mod)): op_val = 1
                elif isinstance(info.node.op, ast.BitOr): op_val = 1
                elif isinstance(info.node.op, ast.BitXor): op_val = 2
                
                lines.append(f"      {r_type}{r_num}_op = {op_val};")
                
                op1 = info.node.operands[0]
                op2 = info.node.operands[1]
                
                val1 = self.signal_map[op1.name] if isinstance(op1, IdentifierNode) else self.signal_map[op1.id]
                val2 = self.signal_map[op2.name] if isinstance(op2, IdentifierNode) else self.signal_map[op2.id]
                
                lines.append(f"      {r_type}{r_num}_sel1 = {val1};")
                lines.append(f"      {r_type}{r_num}_sel2 = {val2};")
                
                lines.append(f"      reg_{r_type}{info.node.id}_en = 1;")
            
            if t < self.max_time:
                lines.append(f"      next_state = SCH_CYCLE_{t+1};")
            else:
                lines.append("      next_state = S_DONE;")
            
            lines.append("    end")
            
        lines.append("    S_DONE: begin")
        lines.append("      result_en = 1;")
        lines.append("      done_next = 1;")
        lines.append("      next_state = S_IDLE;")
        lines.append("    end")
        lines.append("  endcase")
        lines.append("end")
        lines.append("endmodule")
        
        return "\n".join(lines)

    def generate_top_module(self) -> str:
        lines = []
        lines.append("module top(")
        lines.append("  input clk, rst, start,")
        for inp in self.inputs:
            lines.append(f"  input [31:0] {inp},")
        lines.append("  output [31:0] result,")
        lines.append("  output done")
        lines.append(");")
        lines.append("")
        
        lines.append("  wire op_ready, done_next, result_en;")
        
        for r_type, count in self.resources.items():
            for i in range(1, count + 1):
                lines.append(f"  wire [3:0] {r_type.lower()}{i}_sel1, {r_type.lower()}{i}_sel2;")
                if r_type == "LOG":
                    lines.append(f"  wire [1:0] {r_type.lower()}{i}_op;")
                else:
                    lines.append(f"  wire {r_type.lower()}{i}_op;")
                    
        for info in self.schedule_info:
            lines.append(f"  wire reg_{info.node.op_type.lower()}{info.node.id}_en;")
            
        lines.append("")
        
        lines.append("  controller ctrl(")
        lines.append("    .clk(clk), .rst(rst), .start(start),")
        lines.append("    .op_ready(op_ready),")
        lines.append("    .done_next(done_next), .result_en(result_en),")
        
        for r_type, count in self.resources.items():
            for i in range(1, count + 1):
                prefix = f"{r_type.lower()}{i}"
                lines.append(f"    .{prefix}_sel1({prefix}_sel1), .{prefix}_sel2({prefix}_sel2), .{prefix}_op({prefix}_op),")
                
        reg_en_connections = []
        for info in self.schedule_info:
            name = f"reg_{info.node.op_type.lower()}{info.node.id}_en"
            reg_en_connections.append(f".{name}({name})")
        lines.append("    " + ", ".join(reg_en_connections))
        lines.append("  );")
        lines.append("")
        
        lines.append("  datapath dp(")
        lines.append("    .clk(clk), .rst(rst),")
        for inp in self.inputs:
            lines.append(f"    .{inp}({inp}),")
            
        for r_type, count in self.resources.items():
            for i in range(1, count + 1):
                prefix = f"{r_type.lower()}{i}"
                lines.append(f"    .{prefix}_sel1({prefix}_sel1), .{prefix}_sel2({prefix}_sel2), .{prefix}_op({prefix}_op),")
                
        lines.append("    .done_next(done_next), .result_en(result_en),")
        
        reg_en_connections = []
        for info in self.schedule_info:
            name = f"reg_{info.node.op_type.lower()}{info.node.id}_en"
            reg_en_connections.append(f".{name}({name})")
        lines.append("    " + ", ".join(reg_en_connections) + ",")
        
        lines.append("    .result(result), .done(done)")
        lines.append("  );")
        lines.append("endmodule")
        
        return "\n".join(lines)

    def generate_testbench(self) -> str:
        lines = []
        lines.append("`timescale 1ns/1ns")
        lines.append("module tb;")
        lines.append("  reg clk, rst, start;")
        for inp in self.inputs:
            lines.append(f"  reg [31:0] {inp};")
        lines.append("  wire [31:0] result;")
        lines.append("  wire done;")
        lines.append("")
        
        lines.append("  top uut(")
        lines.append("    .clk(clk), .rst(rst), .start(start),")
        for inp in self.inputs:
            lines.append(f"    .{inp}({inp}),")
        lines.append("    .result(result), .done(done)")
        lines.append("  );")
        lines.append("")
        
        lines.append("  initial begin")
        lines.append("    clk = 0;")
        lines.append("    forever #5 clk = ~clk;")
        lines.append("  end")
        lines.append("")
        
        lines.append("  initial begin")
        lines.append("    rst = 1; start = 0;")
        for i, inp in enumerate(self.inputs):
            lines.append(f"    {inp} = {10 * (i + 1)};")
            
        lines.append("    #15 rst = 0;")
        lines.append("    #10 start = 1;")
        lines.append("    #10 start = 0;")
        lines.append("    wait(done);")
        lines.append("    #20;")
        lines.append("    $stop;")
        lines.append("  end")
        lines.append("endmodule")
        
        return "\n".join(lines)

def generate_verilog(folder_path : str, schedule_info : list[ScheduledNodeInfo]):
    generator = VerilogGenerator(schedule_info)
    
    datapath_code = generator.generate_datapath()
    controller_code = generator.generate_controller()
    top_code = generator.generate_top_module()
    tb_code = generator.generate_testbench()
    
    Path(folder_path + "/codes").mkdir(parents=True, exist_ok=True)
    
    with open(folder_path + "/codes/datapath.v", "w") as f:
        f.write(datapath_code)
        
    with open(folder_path + "/codes/controller.v", "w") as f:
        f.write(controller_code)

    with open(folder_path + "/codes/top.v", "w") as f:
        f.write(top_code)

    with open(folder_path + "/codes/tb.v", "w") as f:
        f.write(tb_code)

def save_result(folder_path : str, schedule_info : list[ScheduledNodeInfo]):
    json_output = {}
    with open(folder_path + "/output.json", "w") as file:
        for node_info in schedule_info:
            json_output[node_info.node.id] = {
                "clk": node_info.scheduled_time,
                "resource_type": node_info.node.op_type,
                "resource_num": node_info.resource_num
            }
        json.dump(json_output, file, indent=4)


def calculate_and_print_result(expression: str, dfg_root):
    identifiers = set()
    visited = set()

    def traverse(node):
        if hasattr(node, 'id'):
            if node.id in visited:
                return
            visited.add(node.id)
        
        if isinstance(node, IdentifierNode):
            identifiers.add(node.name)
        elif isinstance(node, OperatorNode):
            for op in node.operands:
                traverse(op)
                
    traverse(dfg_root)
    sorted_inputs = sorted(list(identifiers))
    
    env = {}
    for i, name in enumerate(sorted_inputs):
        val = 10 * (i + 1)
        env[name] = val
        print(f"{name} = {val}")
        
    try:
        expr_for_eval = expression.replace("/", "//")
        result = eval(expr_for_eval, {}, env)
        print(f"\nExpression: {expression}")
        print(f"Result: {result}")
    except Exception as e:
        print(f"Error: {e}")

def run_test(folder_path : str):
    input_file_path = folder_path + "/input.json"
    data = load_input(input_file_path)

    dfg_root = build_dfg(expression=data["Expression"], folder_path=folder_path)

    calculate_and_print_result(data["Expression"], dfg_root)

    schedule_info = schedule_dfg(dfg_root, algorithm=data["Algorithm"], config=data["Config"], folder_path=folder_path)

    save_result(folder_path=folder_path, schedule_info=schedule_info)

    generate_verilog(folder_path=folder_path, schedule_info=schedule_info)

def main():
    if len(sys.argv) > 1:
        run_test(folder_path=sys.argv[1])
    else:
        print("Please provide the input folder path.")

if __name__ == "__main__":
    main()
