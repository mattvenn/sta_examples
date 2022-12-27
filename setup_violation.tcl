read_liberty nangate45_typ.lib
read_verilog flop.v
link_design top
create_clock -name clk -period 10 {clk}
set_input_delay -clock clk 10 {in}
report_checks -path_delay max -digits 3
