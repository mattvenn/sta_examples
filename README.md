# STA examples

Verilog module is 2 flops in series, each with own clock:

    module top (
        input wire in1,
        input wire clk1,
        input wire clk2,
        output wire out);

      wire r1q;
      DFF_X1 r1 (.D(in1), .CK(clk1), .Q(r1q));
      DFF_X1 r2 (.D(r1q), .CK(clk2), .Q(out));
    endmodule

## Setup violation

the tcl file sets both clocks the same, and puts a delay on in1 compared to clk2 of 10ns 

    read_liberty example1_typ.lib
    read_verilog matt.v
    link_design top
    create_clock -name clk1 -period 10 {clk1}
    create_clock -name clk2 -period 10 {clk2}
    set_input_delay -clock clk2 10 {in1}
    report_checks -path_delay max

then running:

    sta setup_violation.tcl

fails with:

    OpenSTA 2.3.3 e3f8c693c0 Copyright (c) 2021, Parallax Software, Inc.
    License GPLv3: GNU GPL version 3 <http://gnu.org/licenses/gpl.html>

    This is free software, and you are free to change and redistribute it
    under certain conditions; type `show_copying' for details. 
    This program comes with ABSOLUTELY NO WARRANTY; for details type `show_warranty'.
    Startpoint: in1 (input port clocked by clk2)
    Endpoint: r1 (rising edge-triggered flip-flop clocked by clk1)
    Path Group: clk1
    Path Type: max

      Delay    Time   Description
    ---------------------------------------------------------
       0.00    0.00   clock clk2 (rise edge)
       0.00    0.00   clock network delay (ideal)
      10.00   10.00 v input external delay
       0.00   10.00 v in1 (in)
       0.00   10.00 v r1/D (DFF_X1)
              10.00   data arrival time

      10.00   10.00   clock clk1 (rise edge)
       0.00   10.00   clock network delay (ideal)
       0.00   10.00   clock reconvergence pessimism
              10.00 ^ r1/CK (DFF_X1)
      -0.04    9.96   library setup time
               9.96   data required time
    ---------------------------------------------------------
               9.96   data required time
             -10.00   data arrival time
    ---------------------------------------------------------
              -0.04   slack (VIOLATED)

## Hold violation

I can't get a hold violation to occur

* how to set clock phase?
* tried with multiple buffers between clk2 and clk1
* tried with external clk2 and input delay on clk2

