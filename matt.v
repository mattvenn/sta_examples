`default_nettype none

module top (
    input wire in1,
    input wire clk1,
    input wire clk2,
    output wire out);

  wire r1q;
 // wire dc1, dc2, dc3;

  //BUF_X1 u3 (.A(dc2), .Z(dc3));
  
  DFF_X1 r1 (.D(in1), .CK(clk1), .Q(r1q));

  DFF_X1 r2 (.D(r1q), .CK(clk2), .Q(out));
endmodule

