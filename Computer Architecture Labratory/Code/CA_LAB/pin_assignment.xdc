# Clock signals
#set_property PACKAGE_PIN E7                 [get_ports CLK_33MHz]
#set_property IOSTANDARD LVCMOS33            [get_ports CLK_33MHz]
#create_clock -period 30.000 -name CLK_33MHz [get_ports CLK_33MHz]

set_property PACKAGE_PIN U18                [get_ports clk]
set_property IOSTANDARD LVCMOS33            [get_ports clk]
create_clock -period 20.000 -name CLK_50MHz [get_ports clk]

# Buttons
set_property PACKAGE_PIN G14                [get_ports rst]
set_property IOSTANDARD LVCMOS33            [get_ports rst]

