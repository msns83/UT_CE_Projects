
################################################################
# This is a generated script based on design: CA_LAB1
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2018.3
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_msg_id "BD_TCL-109" "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source CA_LAB1_script.tcl


# The design that will be created by this Tcl script contains the following 
# module references:
# data_hazard_unit, ex_register_file, fetch_register_file, forward, id_register_file, id_top_module, mem_register_file, mux2to1_32bit, top_ex, fetch_instruction

# Please add the sources of those modules before sourcing this Tcl script.

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xc7z010clg400-1
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name CA_LAB1

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_msg_id "BD_TCL-001" "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_msg_id "BD_TCL-002" "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_msg_id "BD_TCL-003" "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_msg_id "BD_TCL-004" "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_msg_id "BD_TCL-005" "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_msg_id "BD_TCL-114" "ERROR" $errMsg}
   return $nRet
}

##################################################################
# DESIGN PROCs
##################################################################


# Hierarchical cell: Mem_Stage
proc create_hier_cell_Mem_Stage { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_Mem_Stage() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins

  # Create pins
  create_bd_pin -dir I -from 31 -to 0 Din
  create_bd_pin -dir I clk
  create_bd_pin -dir I -from 31 -to 0 d
  create_bd_pin -dir O -from 31 -to 0 spo
  create_bd_pin -dir I we

  # Create instance: dist_mem_gen_0, and set properties
  set dist_mem_gen_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:dist_mem_gen:8.0 dist_mem_gen_0 ]
  set_property -dict [ list \
   CONFIG.data_width {32} \
   CONFIG.depth {2048} \
 ] $dist_mem_gen_0

  # Create instance: xlslice_0, and set properties
  set xlslice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_0 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {10} \
   CONFIG.DOUT_WIDTH {11} \
 ] $xlslice_0

  # Create port connections
  connect_bd_net -net clk_0_1 [get_bd_pins clk] [get_bd_pins dist_mem_gen_0/clk]
  connect_bd_net -net dist_mem_gen_0_spo [get_bd_pins spo] [get_bd_pins dist_mem_gen_0/spo]
  connect_bd_net -net ex_register_file_0_alu_res_out [get_bd_pins Din] [get_bd_pins xlslice_0/Din]
  connect_bd_net -net ex_register_file_0_mem_w_en_out [get_bd_pins we] [get_bd_pins dist_mem_gen_0/we]
  connect_bd_net -net ex_register_file_0_val_rm_out [get_bd_pins d] [get_bd_pins dist_mem_gen_0/d]
  connect_bd_net -net xlslice_0_Dout [get_bd_pins dist_mem_gen_0/a] [get_bd_pins xlslice_0/Dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: IF_Stage
proc create_hier_cell_IF_Stage { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_IF_Stage() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins

  # Create pins
  create_bd_pin -dir I branch_tacken_1
  create_bd_pin -dir I -type clk clk
  create_bd_pin -dir O -from 31 -to 0 douta
  create_bd_pin -dir I freeze
  create_bd_pin -dir I -from 31 -to 0 mux_inp_BA
  create_bd_pin -dir I -type rst rst
  create_bd_pin -dir O -from 31 -to 0 updated_pc

  # Create instance: dist_mem_gen_0, and set properties
  set dist_mem_gen_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:dist_mem_gen:8.0 dist_mem_gen_0 ]
  set_property -dict [ list \
   CONFIG.coefficient_file {../../../../../../../../Files/output_ultimate.coe} \
   CONFIG.data_width {32} \
   CONFIG.depth {8192} \
   CONFIG.memory_type {rom} \
 ] $dist_mem_gen_0

  # Create instance: fetch_instruction_0, and set properties
  set block_name fetch_instruction
  set block_cell_name fetch_instruction_0
  if { [catch {set fetch_instruction_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $fetch_instruction_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: xlslice_0, and set properties
  set xlslice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_0 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {12} \
   CONFIG.DIN_TO {0} \
   CONFIG.DOUT_WIDTH {13} \
 ] $xlslice_0

  # Create port connections
  connect_bd_net -net branch_tacken1_1 [get_bd_pins branch_tacken_1] [get_bd_pins fetch_instruction_0/branch_tacken]
  connect_bd_net -net clk_0_1 [get_bd_pins clk] [get_bd_pins fetch_instruction_0/clk]
  connect_bd_net -net debouncer_0_SIGNAL_O [get_bd_pins rst] [get_bd_pins fetch_instruction_0/rst]
  connect_bd_net -net dist_mem_gen_0_spo [get_bd_pins douta] [get_bd_pins dist_mem_gen_0/spo]
  connect_bd_net -net fetch_instruction_0_memory_in [get_bd_pins fetch_instruction_0/memory_in] [get_bd_pins xlslice_0/Din]
  connect_bd_net -net fetch_instruction_0_updated_pc [get_bd_pins updated_pc] [get_bd_pins fetch_instruction_0/updated_pc]
  connect_bd_net -net freeze_1 [get_bd_pins freeze] [get_bd_pins fetch_instruction_0/freeze]
  connect_bd_net -net mux_inp_BA_1 [get_bd_pins mux_inp_BA] [get_bd_pins fetch_instruction_0/mux_inp_BA]
  connect_bd_net -net xlslice_0_Dout [get_bd_pins dist_mem_gen_0/a] [get_bd_pins xlslice_0/Dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}


# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports

  # Create ports
  set clk [ create_bd_port -dir I -type clk clk ]
  set_property -dict [ list \
   CONFIG.ASSOCIATED_RESET {rst} \
 ] $clk
  set fwd_en_0 [ create_bd_port -dir I fwd_en_0 ]
  set r0_0 [ create_bd_port -dir O -from 31 -to 0 r0_0 ]
  set r1_0 [ create_bd_port -dir O -from 31 -to 0 r1_0 ]
  set r2_0 [ create_bd_port -dir O -from 31 -to 0 r2_0 ]
  set r3_0 [ create_bd_port -dir O -from 31 -to 0 r3_0 ]
  set r4_0 [ create_bd_port -dir O -from 31 -to 0 r4_0 ]
  set r5_0 [ create_bd_port -dir O -from 31 -to 0 r5_0 ]
  set r6_0 [ create_bd_port -dir O -from 31 -to 0 r6_0 ]
  set rst [ create_bd_port -dir I -type rst rst ]

  # Create instance: IF_Stage
  create_hier_cell_IF_Stage [current_bd_instance .] IF_Stage

  # Create instance: Mem_Stage
  create_hier_cell_Mem_Stage [current_bd_instance .] Mem_Stage

  # Create instance: data_hazard_unit_0, and set properties
  set block_name data_hazard_unit
  set block_cell_name data_hazard_unit_0
  if { [catch {set data_hazard_unit_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $data_hazard_unit_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: ex_register_file_0, and set properties
  set block_name ex_register_file
  set block_cell_name ex_register_file_0
  if { [catch {set ex_register_file_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $ex_register_file_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: fetch_register_file_0, and set properties
  set block_name fetch_register_file
  set block_cell_name fetch_register_file_0
  if { [catch {set fetch_register_file_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $fetch_register_file_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: forward_0, and set properties
  set block_name forward
  set block_cell_name forward_0
  if { [catch {set forward_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $forward_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: id_register_file_0, and set properties
  set block_name id_register_file
  set block_cell_name id_register_file_0
  if { [catch {set id_register_file_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $id_register_file_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: id_top_module_0, and set properties
  set block_name id_top_module
  set block_cell_name id_top_module_0
  if { [catch {set id_top_module_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $id_top_module_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: mem_register_file_0, and set properties
  set block_name mem_register_file
  set block_cell_name mem_register_file_0
  if { [catch {set mem_register_file_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $mem_register_file_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: mux2to1_32bit_0, and set properties
  set block_name mux2to1_32bit
  set block_cell_name mux2to1_32bit_0
  if { [catch {set mux2to1_32bit_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $mux2to1_32bit_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: top_ex_0, and set properties
  set block_name top_ex
  set block_cell_name top_ex_0
  if { [catch {set top_ex_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $top_ex_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create port connections
  connect_bd_net -net blk_mem_gen_0_douta [get_bd_pins IF_Stage/douta] [get_bd_pins fetch_register_file_0/instruction]
  connect_bd_net -net clk_0_1 [get_bd_ports clk] [get_bd_pins IF_Stage/clk] [get_bd_pins Mem_Stage/clk] [get_bd_pins ex_register_file_0/clk] [get_bd_pins fetch_register_file_0/clk] [get_bd_pins id_register_file_0/clk] [get_bd_pins id_top_module_0/clk] [get_bd_pins mem_register_file_0/clk] [get_bd_pins top_ex_0/clk]
  connect_bd_net -net data_hazard_unit_0_hazard [get_bd_pins IF_Stage/freeze] [get_bd_pins data_hazard_unit_0/hazard] [get_bd_pins fetch_register_file_0/freeze] [get_bd_pins id_top_module_0/hazard]
  connect_bd_net -net debouncer_0_SIGNAL_O [get_bd_ports rst] [get_bd_pins IF_Stage/rst] [get_bd_pins ex_register_file_0/rst] [get_bd_pins fetch_register_file_0/rst] [get_bd_pins id_register_file_0/rst] [get_bd_pins id_top_module_0/rst] [get_bd_pins mem_register_file_0/rst] [get_bd_pins top_ex_0/rst]
  connect_bd_net -net dist_mem_gen_0_spo [get_bd_pins Mem_Stage/spo] [get_bd_pins mem_register_file_0/mem_out]
  connect_bd_net -net ex_register_file_0_alu_res_out [get_bd_pins Mem_Stage/Din] [get_bd_pins ex_register_file_0/alu_res_out] [get_bd_pins mem_register_file_0/alu_res] [get_bd_pins top_ex_0/alu_res_mem]
  connect_bd_net -net ex_register_file_0_dest_out [get_bd_pins data_hazard_unit_0/mem_dest] [get_bd_pins ex_register_file_0/dest_out] [get_bd_pins forward_0/mem_dest] [get_bd_pins mem_register_file_0/dest]
  connect_bd_net -net ex_register_file_0_mem_r_en_out [get_bd_pins ex_register_file_0/mem_r_en_out] [get_bd_pins mem_register_file_0/mem_r_en]
  connect_bd_net -net ex_register_file_0_mem_w_en_out [get_bd_pins Mem_Stage/we] [get_bd_pins ex_register_file_0/mem_w_en_out]
  connect_bd_net -net ex_register_file_0_val_rm_out [get_bd_pins Mem_Stage/d] [get_bd_pins ex_register_file_0/val_rm_out]
  connect_bd_net -net ex_register_file_0_wb_en_out [get_bd_pins data_hazard_unit_0/mem_wb_en] [get_bd_pins ex_register_file_0/wb_en_out] [get_bd_pins forward_0/mem_wb_en] [get_bd_pins mem_register_file_0/wb_en]
  connect_bd_net -net fetch_instruction_0_updated_pc [get_bd_pins IF_Stage/updated_pc] [get_bd_pins fetch_register_file_0/updated_pc]
  connect_bd_net -net fetch_register_file_0_instruction_reg [get_bd_pins fetch_register_file_0/instruction_reg] [get_bd_pins id_top_module_0/instr]
  connect_bd_net -net fetch_register_file_0_updated_pc_reg [get_bd_pins fetch_register_file_0/updated_pc_reg] [get_bd_pins id_register_file_0/pc]
  connect_bd_net -net forward_0_sel_src1 [get_bd_pins forward_0/sel_src1] [get_bd_pins top_ex_0/sel_src1]
  connect_bd_net -net forward_0_sel_src2 [get_bd_pins forward_0/sel_src2] [get_bd_pins top_ex_0/sel_src2]
  connect_bd_net -net fwd_en_0_1 [get_bd_ports fwd_en_0] [get_bd_pins data_hazard_unit_0/fwd_en] [get_bd_pins forward_0/fwd_en]
  connect_bd_net -net id_register_file_0_addr_rm_out [get_bd_pins forward_0/src2_exe] [get_bd_pins id_register_file_0/addr_rm_out]
  connect_bd_net -net id_register_file_0_addr_rn_out [get_bd_pins forward_0/src1_exe] [get_bd_pins id_register_file_0/addr_rn_out]
  connect_bd_net -net id_register_file_0_control_unit_out_out [get_bd_pins id_register_file_0/control_unit_out_out] [get_bd_pins top_ex_0/control_unit_out]
  connect_bd_net -net id_register_file_0_dest_out [get_bd_pins id_register_file_0/dest_out] [get_bd_pins top_ex_0/dest]
  connect_bd_net -net id_register_file_0_imm_out [get_bd_pins id_register_file_0/imm_out] [get_bd_pins top_ex_0/imm]
  connect_bd_net -net id_register_file_0_pc_out [get_bd_pins id_register_file_0/pc_out] [get_bd_pins top_ex_0/pc]
  connect_bd_net -net id_register_file_0_shift_operand_out [get_bd_pins id_register_file_0/shift_operand_out] [get_bd_pins top_ex_0/shift_operand]
  connect_bd_net -net id_register_file_0_signed_imm_24_out [get_bd_pins id_register_file_0/signed_imm_24_out] [get_bd_pins top_ex_0/signed_imm_24]
  connect_bd_net -net id_register_file_0_status_reg_out [get_bd_pins id_register_file_0/status_reg_out] [get_bd_pins top_ex_0/status_reg_c]
  connect_bd_net -net id_register_file_0_val_rm_out [get_bd_pins id_register_file_0/val_rm_out] [get_bd_pins top_ex_0/val_rm]
  connect_bd_net -net id_register_file_0_val_rn_out [get_bd_pins id_register_file_0/val_rn_out] [get_bd_pins top_ex_0/val_rn]
  connect_bd_net -net id_top_module_0_addr_rm [get_bd_pins data_hazard_unit_0/rm] [get_bd_pins id_register_file_0/addr_rm] [get_bd_pins id_top_module_0/addr_rm]
  connect_bd_net -net id_top_module_0_addr_rn [get_bd_pins data_hazard_unit_0/rn] [get_bd_pins id_register_file_0/addr_rn] [get_bd_pins id_top_module_0/addr_rn]
  connect_bd_net -net id_top_module_0_cuoo [get_bd_pins id_register_file_0/control_unit_out] [get_bd_pins id_top_module_0/cuoo]
  connect_bd_net -net id_top_module_0_dest [get_bd_pins id_register_file_0/dest] [get_bd_pins id_top_module_0/dest]
  connect_bd_net -net id_top_module_0_imm [get_bd_pins id_register_file_0/imm] [get_bd_pins id_top_module_0/imm]
  connect_bd_net -net id_top_module_0_r0 [get_bd_ports r0_0] [get_bd_pins id_top_module_0/r0]
  connect_bd_net -net id_top_module_0_r1 [get_bd_ports r1_0] [get_bd_pins id_top_module_0/r1]
  connect_bd_net -net id_top_module_0_r2 [get_bd_ports r2_0] [get_bd_pins id_top_module_0/r2]
  connect_bd_net -net id_top_module_0_r3 [get_bd_ports r3_0] [get_bd_pins id_top_module_0/r3]
  connect_bd_net -net id_top_module_0_r4 [get_bd_ports r4_0] [get_bd_pins id_top_module_0/r4]
  connect_bd_net -net id_top_module_0_r5 [get_bd_ports r5_0] [get_bd_pins id_top_module_0/r5]
  connect_bd_net -net id_top_module_0_r6 [get_bd_ports r6_0] [get_bd_pins id_top_module_0/r6]
  connect_bd_net -net id_top_module_0_shift_operand [get_bd_pins id_register_file_0/shift_operand] [get_bd_pins id_top_module_0/shift_operand]
  connect_bd_net -net id_top_module_0_signed_imm_24 [get_bd_pins id_register_file_0/signed_imm_24] [get_bd_pins id_top_module_0/signed_imm_24]
  connect_bd_net -net id_top_module_0_two_src [get_bd_pins data_hazard_unit_0/two_src] [get_bd_pins id_top_module_0/two_src]
  connect_bd_net -net id_top_module_0_val_rm [get_bd_pins id_register_file_0/val_rm] [get_bd_pins id_top_module_0/val_rm]
  connect_bd_net -net id_top_module_0_val_rn [get_bd_pins id_register_file_0/val_rn] [get_bd_pins id_top_module_0/val_rn]
  connect_bd_net -net mem_register_file_0_alu_res_out [get_bd_pins mem_register_file_0/alu_res_out] [get_bd_pins mux2to1_32bit_0/ALU_Res]
  connect_bd_net -net mem_register_file_0_dest_out [get_bd_pins forward_0/wb_dest] [get_bd_pins id_top_module_0/w_dest] [get_bd_pins mem_register_file_0/dest_out]
  connect_bd_net -net mem_register_file_0_mem_out_out [get_bd_pins mem_register_file_0/mem_out_out] [get_bd_pins mux2to1_32bit_0/Mem_Data]
  connect_bd_net -net mem_register_file_0_mem_r_en_out [get_bd_pins mem_register_file_0/mem_r_en_out] [get_bd_pins mux2to1_32bit_0/MEM_R_EN]
  connect_bd_net -net mem_register_file_0_wb_en_out [get_bd_pins forward_0/wb_wb_en] [get_bd_pins id_top_module_0/w_en] [get_bd_pins mem_register_file_0/wb_en_out]
  connect_bd_net -net mux2to1_32bit_0_WB_Value [get_bd_pins id_top_module_0/w_val] [get_bd_pins mux2to1_32bit_0/WB_Value] [get_bd_pins top_ex_0/wb_value]
  connect_bd_net -net top_ex_0_alu_res_out [get_bd_pins ex_register_file_0/alu_res] [get_bd_pins top_ex_0/alu_res_out]
  connect_bd_net -net top_ex_0_branch_addr [get_bd_pins IF_Stage/mux_inp_BA] [get_bd_pins top_ex_0/branch_addr]
  connect_bd_net -net top_ex_0_branch_tacken [get_bd_pins IF_Stage/branch_tacken_1] [get_bd_pins fetch_register_file_0/flush] [get_bd_pins id_register_file_0/flush] [get_bd_pins top_ex_0/branch_tacken]
  connect_bd_net -net top_ex_0_carry_out [get_bd_pins id_register_file_0/status_reg] [get_bd_pins top_ex_0/carry_out]
  connect_bd_net -net top_ex_0_dest_out [get_bd_pins ex_register_file_0/dest] [get_bd_pins top_ex_0/dest_out]
  connect_bd_net -net top_ex_0_exe_dest [get_bd_pins data_hazard_unit_0/exe_dest] [get_bd_pins top_ex_0/exe_dest]
  connect_bd_net -net top_ex_0_exe_wb_en [get_bd_pins data_hazard_unit_0/exe_wb_en] [get_bd_pins top_ex_0/exe_wb_en]
  connect_bd_net -net top_ex_0_mem_r_en_out [get_bd_pins data_hazard_unit_0/exe_mem_r_en] [get_bd_pins ex_register_file_0/mem_r_en] [get_bd_pins top_ex_0/mem_r_en_out]
  connect_bd_net -net top_ex_0_mem_w_en_out [get_bd_pins ex_register_file_0/mem_w_en] [get_bd_pins top_ex_0/mem_w_en_out]
  connect_bd_net -net top_ex_0_val_rm_out [get_bd_pins ex_register_file_0/val_rm] [get_bd_pins top_ex_0/val_rm_out]
  connect_bd_net -net top_ex_0_wb_en_out [get_bd_pins ex_register_file_0/wb_en] [get_bd_pins top_ex_0/wb_en_out]
  connect_bd_net -net top_ex_0_zcvn_out [get_bd_pins id_top_module_0/zcvn] [get_bd_pins top_ex_0/zcvn_out]

  # Create address segments


  # Restore current instance
  current_bd_instance $oldCurInst

  validate_bd_design
  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


