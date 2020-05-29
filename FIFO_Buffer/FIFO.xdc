# constraints for FIFO buffer to work with Blackboard 

# Constraints for CLK
set_property PACKAGE_PIN H16 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -name external_clock -period 10.00 [get_ports clk]

set_property PACKAGE_PIN N20 [get_ports {dout[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {dout[0]}]

set_property PACKAGE_PIN P20 [get_ports {dout[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {dout[1]}]

set_property PACKAGE_PIN R19 [get_ports {dout[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {dout[2]}]

set_property PACKAGE_PIN R17 [get_ports {din[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {din[0]}]

set_property PACKAGE_PIN U20 [get_ports {din[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {din[1]}]

set_property PACKAGE_PIN R16 [get_ports {din[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {din[2]}]

set_property PACKAGE_PIN W14 [get_ports {rst}]
set_property IOSTANDARD LVCMOS33 [get_ports {rst}]

set_property PACKAGE_PIN P15 [get_ports {read}]
set_property IOSTANDARD LVCMOS33 [get_ports {read}]

set_property PACKAGE_PIN W13 [get_ports {write}]
set_property IOSTANDARD LVCMOS33 [get_ports {write}]

set_property PACKAGE_PIN Y19 [get_ports {empty}]
set_property IOSTANDARD LVCMOS33 [get_ports {empty}]

set_property PACKAGE_PIN W20 [get_ports {full}]
set_property IOSTANDARD LVCMOS33 [get_ports {full}]
