
# System Clock
set_property PACKAGE_PIN W5 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -period 10.000 -name sys_clk_pin -waveform {0.000 5.000} -add [get_ports clk]


#7 segment display
set_property PACKAGE_PIN W7 [get_ports {seg[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[0]}]
set_property PACKAGE_PIN W6 [get_ports {seg[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[1]}]
set_property PACKAGE_PIN U8 [get_ports {seg[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[2]}]
set_property PACKAGE_PIN V8 [get_ports {seg[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[3]}]
set_property PACKAGE_PIN U5 [get_ports {seg[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[4]}]
set_property PACKAGE_PIN V5 [get_ports {seg[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[5]}]
set_property PACKAGE_PIN U7 [get_ports {seg[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[6]}]

set_property PACKAGE_PIN V7 [get_ports dp]
set_property IOSTANDARD LVCMOS33 [get_ports dp]

set_property PACKAGE_PIN U2 [get_ports {an[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {an[0]}]
set_property PACKAGE_PIN U4 [get_ports {an[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {an[1]}]
set_property PACKAGE_PIN V4 [get_ports {an[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {an[2]}]
set_property PACKAGE_PIN W4 [get_ports {an[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {an[3]}]


# Reset(btnB)
set_property PACKAGE_PIN U17 [get_ports reset]
set_property IOSTANDARD LVCMOS33 [get_ports reset]

# Pmod (JB)
#Sch name = JB1
set_property PACKAGE_PIN A14 [get_ports {flashair_data[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {flashair_data[0]}]
#Sch name = JB2
set_property PACKAGE_PIN A16 [get_ports {flashair_data[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {flashair_data[1]}]
#Sch name = JB3
set_property PACKAGE_PIN B15 [get_ports {flashair_data[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {flashair_data[2]}]
#Sch name = JB4
set_property PACKAGE_PIN B16 [get_ports {flashair_data[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {flashair_data[3]}]
#Sch name = JB7
set_property PACKAGE_PIN A15 [get_ports flashair_ack]
set_property IOSTANDARD LVCMOS33 [get_ports flashair_ack]

