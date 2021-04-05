//************************************************************************
// Filename      : stopwatch_disp.v
// Author        : hp
// Function      : stopwatch display unit
// Last Modified : Date: 2009-03-10
// Revision      : Revision: 1
// Copyright (c), Laboratory for Reliable Computing (LaRC), EE, NTHU
// All rights reserved
//************************************************************************
`include "global.v"
module stopwatch(
  segs, // 7 segment display control
  ssd_ctl, // scan control for 7-segment display
  clk, // clock
  rst_n, // low active reset
  in // input control for FSM
);

output [`SSD_BIT_WIDTH-1:0] segs; // 7 segment display control
output [`SSD_DIGIT_NUM-1:0] ssd_ctl; // scan control for 7-segment display
input clk; // clock
input rst_n; // low active reset
input in; // input control for FSM

wire [`SSD_SCAN_CTL_BIT_WIDTH-1:0] ssd_ctl_en; // divided output for ssd scan control
wire clk_d; // divided clock

wire count_enable; // if count is enabled

wire [`BCD_BIT_WIDTH-1:0] dig0,dig1; // second counter output
wire [`BCD_BIT_WIDTH-1:0] ssd_in; // input to 7-segment display decoder

//**************************************************************
// pulse
//**************************************************************
wire led_1; // 1Hz divided clock
wire led_pb; // LED display output (push button)
wire clk_100;
wire led_1pulse; // LED display output (1 pulse)
// Declare internal nodes
wire pb_debounced; // push button debounced output

clock_generator U_cg(
  .clk(clk), // clock from crystal
  .rst_n(rst_n), // active low reset
  .clk_1(led_1), // generated 1 Hz clock
  .clk_100(clk_100) // generated 100 Hz clock
);

// debounce circuit
debounce_circuit U_dc(
  .clk(clk_100), // clock control
  .rst_n(rst_n), // reset
  .pb_in(in), //push button input
  .pb_debounced(led_pb) // debounced push button output
);

// 1 pulse generation circuit
one_pulse U_op(
  .clk(led_1),  // clock input
  .rst_n(rst_n), //active low reset
  .in_trig(led_pb), // input trigger
  .out_pulse(led_1pulse) // output one pulse 
);

//**************************************************************
// Functional block
//**************************************************************
// frequency divider 1/(2^27)
freqdiv27 U_FD(
  .clk_out(clk_d), // divided clock
  .clk_ctl(ssd_ctl_en), // divided clock for scan control 
  .clk(clk), // clock from the crystal
  .rst_n(rst_n) // low active reset
);

// finite state machine
fsm U_fsm(
  .count_enable(count_enable),  // if counter is enabled 
  .in(led_1pulse), //input control
  .clk(clk_d), // global clock signal
  .rst_n(rst_n)  // low active reset
);

// stopwatch module
downcounter_2d U_sw(
  .digit1(dig1),  // 2nd digit of the down counter
  .digit0(dig0),  // 1st digit of the down counter
  .clk(clk_d),  // global clock
  .rst_n(rst_n),  // low active reset
  .en(count_enable) // enable/disable for the stopwatch
);

//**************************************************************
// Display block
//**************************************************************
// BCD to 7-segment display decoding
// seven-segment display decoder for DISP1

// Scan control
scan_ctl U_SC(
  .ssd_ctl(ssd_ctl), // ssd display control signal 
  .ssd_in(ssd_in), // output to ssd display
  .in0(4'b1111), // 1st input
  .in1(4'b1111), // 2nd input
  .in2(dig1), // 3rd input
  .in3(dig0),  // 4th input
  .ssd_ctl_en(ssd_ctl_en) // divided clock for scan control
);

// binary to 7-segment display decoder
display U_display(
  .segs(segs), // 7-segment display output
  .bin(ssd_in)  // BCD number input
);

endmodule
