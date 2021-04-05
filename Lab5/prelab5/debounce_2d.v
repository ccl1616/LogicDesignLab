`timescale 1ns / 1ps
`include "global.v"
module debounce_2d(
    clk,
    rst_n,
    pb_in0,
    pb_in1,
    // output
    pb_debounced0,
    pb_debounced1
);

input clk;
input rst_n;
input pb_in0;
input pb_in1;
output pb_debounced0
output pb_debounced1;

debounce_circuit U_pb0(
    .clk(clk), // clock control
    .rst_n(rst_n), // reset
    .pb_in(pn_in0), //push button input
    .pb_debounced(pb_debounced0) // debounced push button output
);
debounce_circuit U_pb1(
    .clk(clk), // clock control
    .rst_n(rst_n), // reset
    .pb_in(pn_in1), //push button input
    .pb_debounced(pb_debounced1) // debounced push button output
);

endmodule