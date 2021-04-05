`timescale 1ns/1ps
`include "global.v"
module onepulse_2d{
    clk,
    rst_n,
    in_trig0,
    in_trig1,
    // output
    out_pulse0,
    out_pulse1
};
input clk;
input rst_n;
input in_trig0;
input in_trig1;
// output
output out_pulse0;
output out_pulse1;

one_pulse U_p0(
    .clk(clk),  // clock input
    .rst_n(rst_n), //active low reset
    .in_trig(intrig0), // input trigger
    .out_pulse(out_pulse0) // output one pulse 
);
one_pulse U_p0(
    .clk(clk),  // clock input
    .rst_n(rst_n), //active low reset
    .in_trig(intrig1), // input trigger
    .out_pulse(out_pulse1) // output one pulse 
);

endmodule