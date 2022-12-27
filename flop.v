`default_nettype none

module top (
    input wire in,
    input wire clk,
    output wire out);

  DFF_X1 q1 (.D(in), .CK(clk), .Q(out));
endmodule

