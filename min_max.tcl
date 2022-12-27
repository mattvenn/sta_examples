read_liberty nangate45_typ.lib
read_verilog flop.v
link_design top
create_clock -name clk -period 10 {clk}
set_input_delay -clock clk -min 0 {in}
set_input_delay -clock clk -max 5 {in}
report_checks -path_delay min_max -digits 3
