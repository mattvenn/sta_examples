create_clock [get_ports $::env(CLOCK_PORT)]  -name $::env(CLOCK_PORT)  -period $::env(CLOCK_PERIOD)

set_input_delay -clock clk 10 {in}

#set_output_delay -min -1.5 -clock [get_clocks clk_scan_out] [get_ports {scan_data_out}]
#set_output_delay -max  1.5 -clock [get_clocks clk_scan_out] [get_ports {scan_data_out}]
