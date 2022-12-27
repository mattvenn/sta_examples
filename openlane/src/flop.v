`default_nettype none

module flop (
    input wire in,
    input wire clk,
    output wire out);

//  DFF_X1 q1 (.D(in), .CK(clk), .Q(out));
  sky130_fd_sc_hd__dfxtp_1 q1(.D(in), .CLK(clk), .Q(out));
endmodule

