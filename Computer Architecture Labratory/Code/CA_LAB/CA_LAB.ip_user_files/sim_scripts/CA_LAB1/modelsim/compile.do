vlib modelsim_lib/work
vlib modelsim_lib/msim

vlib modelsim_lib/msim/xil_defaultlib
vlib modelsim_lib/msim/xlslice_v1_0_1
vlib modelsim_lib/msim/dist_mem_gen_v8_0_12

vmap xil_defaultlib modelsim_lib/msim/xil_defaultlib
vmap xlslice_v1_0_1 modelsim_lib/msim/xlslice_v1_0_1
vmap dist_mem_gen_v8_0_12 modelsim_lib/msim/dist_mem_gen_v8_0_12

vlog -work xil_defaultlib -64 -incr \
"../../../bd/CA_LAB1/ip/CA_LAB1_fetch_instruction_0_0/sim/CA_LAB1_fetch_instruction_0_0.v" \

vlog -work xlslice_v1_0_1 -64 -incr \
"../../../../CA_LAB.srcs/sources_1/bd/CA_LAB1/ipshared/f3db/hdl/xlslice_v1_0_vl_rfs.v" \

vlog -work xil_defaultlib -64 -incr \
"../../../bd/CA_LAB1/ip/CA_LAB1_xlslice_0_0/sim/CA_LAB1_xlslice_0_0.v" \
"../../../bd/CA_LAB1/ip/CA_LAB1_fetch_register_file_0_0/sim/CA_LAB1_fetch_register_file_0_0.v" \
"../../../bd/CA_LAB1/sim/CA_LAB1.v" \

vlog -work dist_mem_gen_v8_0_12 -64 -incr \
"../../../../CA_LAB.srcs/sources_1/bd/CA_LAB1/ipshared/d46a/simulation/dist_mem_gen_v8_0.v" \

vlog -work xil_defaultlib -64 -incr \
"../../../bd/CA_LAB1/ip/CA_LAB1_dist_mem_gen_0_1/sim/CA_LAB1_dist_mem_gen_0_1.v" \
"../../../bd/CA_LAB1/ip/CA_LAB1_id_top_module_0_0/sim/CA_LAB1_id_top_module_0_0.v" \
"../../../bd/CA_LAB1/ip/CA_LAB1_id_register_file_0_0/sim/CA_LAB1_id_register_file_0_0.v" \
"../../../bd/CA_LAB1/ip/CA_LAB1_top_ex_0_0/sim/CA_LAB1_top_ex_0_0.v" \
"../../../bd/CA_LAB1/ip/CA_LAB1_ex_register_file_0_0/sim/CA_LAB1_ex_register_file_0_0.v" \
"../../../bd/CA_LAB1/ip/CA_LAB1_data_hazard_unit_0_0/sim/CA_LAB1_data_hazard_unit_0_0.v" \
"../../../bd/CA_LAB1/ip/CA_LAB1_dist_mem_gen_0_0/sim/CA_LAB1_dist_mem_gen_0_0.v" \
"../../../bd/CA_LAB1/ip/CA_LAB1_mem_register_file_0_0/sim/CA_LAB1_mem_register_file_0_0.v" \
"../../../bd/CA_LAB1/ip/CA_LAB1_mux2to1_32bit_0_0/sim/CA_LAB1_mux2to1_32bit_0_0.v" \
"../../../bd/CA_LAB1/ip/CA_LAB1_xlslice_0_1/sim/CA_LAB1_xlslice_0_1.v" \
"../../../bd/CA_LAB1/ip/CA_LAB1_forward_0_0/sim/CA_LAB1_forward_0_0.v" \

vlog -work xil_defaultlib \
"glbl.v"

