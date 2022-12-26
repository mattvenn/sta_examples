read_liberty example1_typ.lib
read_verilog matt.v
link_design top
create_clock -name clk1 -period 10 {clk1}
create_clock -name clk2 -period 10 {clk2}
set_input_delay -clock clk2 10 {in1}
report_checks -path_delay max
