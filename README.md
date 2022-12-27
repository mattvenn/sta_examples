# STA examples

from libery file (line 45348), I think that DFF_X1 setup is 0.035 and hold is 0.03.
Not sure whether to look at rise or fall constraints, and picking the middle number out of the matrix.

Can see in the setup check the library setup time is 0.037
can see in the hold check lib hold time is 0.003

default unit is 1ns

Verilog module is 2 flops in series, each with own clock:

    module top (
        input wire in,
        input wire clk,
        output wire out);

      DFF_X1 q1 (.D(in), .CK(clk), .Q(out));
    endmodule

## Setup violation

the setup_violation.tcl file puts a delay on in compared to clk of 10ns 

running:

    make setup

fails with:

    sta -exit -no_splash setup_violation.tcl
    Startpoint: in (input port clocked by clk)
    Endpoint: q1 (rising edge-triggered flip-flop clocked by clk)
    Path Group: clk
    Path Type: max

      Delay    Time   Description
    ---------------------------------------------------------
       0.00    0.00   clock clk (rise edge)
       0.00    0.00   clock network delay (ideal)
      10.00   10.00 v input external delay
       0.00   10.00 v in (in)
       0.00   10.00 v q1/D (DFF_X1)
              10.00   data arrival time

      10.00   10.00   clock clk (rise edge)
       0.00   10.00   clock network delay (ideal)
       0.00   10.00   clock reconvergence pessimism
              10.00 ^ q1/CK (DFF_X1)
      -0.04    9.96   library setup time
               9.96   data required time
    ---------------------------------------------------------
               9.96   data required time
             -10.00   data arrival time
    ---------------------------------------------------------
              -0.04   slack (VIOLATED)

## Hold violation

the hold_violation.tcl file sets 0 delay on in

running:

    make hold

fails with:

    sta -exit -no_splash hold_violation.tcl
    Startpoint: in (input port clocked by clk)
    Endpoint: q1 (rising edge-triggered flip-flop clocked by clk)
    Path Group: clk
    Path Type: min

       Delay     Time   Description
    -----------------------------------------------------------
       0.000    0.000   clock clk (rise edge)
       0.000    0.000   clock network delay (ideal)
       0.000    0.000 ^ input external delay
       0.000    0.000 ^ in (in)
       0.000    0.000 ^ q1/D (DFF_X1)
                0.000   data arrival time

       0.000    0.000   clock clk (rise edge)
       0.000    0.000   clock network delay (ideal)
       0.000    0.000   clock reconvergence pessimism
                0.000 ^ q1/CK (DFF_X1)
       0.003    0.003   library hold time
                0.003   data required time
    -----------------------------------------------------------
                0.003   data required time
               -0.000   data arrival time
    -----------------------------------------------------------
               -0.003   slack (VIOLATED)


## OpenLane notes

trying with a very simple setup (see openlane dir)
with a base.sdc like this:

    create_clock [get_ports $::env(CLOCK_PORT)]  -name $::env(CLOCK_PORT)  -period $::env(CLOCK_PERIOD)
    set_input_delay -clock clk 10 {in}

And changing the input delay:

* With no base sdc, passes
* with base sdc and 10 for delay, flow fails with setup violation
* with base sdc and 0 delay, passes.

All GDS have 1 flop and 2 buffers, one on input, one on output.
Very slight variation - the 0 delay version, the output has a buffer instead of clkbuffer for the output buffer.

I was expecting the tools to prevent the flow from failing.
