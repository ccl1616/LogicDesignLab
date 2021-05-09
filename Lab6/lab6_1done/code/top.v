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
module lapstopwatch(
  led,
  segs, // 7 segment display control
  ssd_ctl, // scan control for 7-segment display
  clk, // clock
  rst_n, // low active reset
  in0, 
  in1
);
output [15:0]led;
output [`SSD_BIT_WIDTH-1:0] segs; // 7 segment display control
output [`SSD_DIGIT_NUM-1:0] ssd_ctl; // scan control for 7-segment display
input clk; // clock
input rst_n; // low active reset
input in0; // input control for FSM
input in1;

wire [`SSD_SCAN_CTL_BIT_WIDTH-1:0] ssd_ctl_en; // divided output for ssd scan control
wire clk_d; // divided clock

wire count_enable; // if count is enabled
wire [`BCD_BIT_WIDTH-1:0] dig0,dig1,dig2,dig3; // second counter output
wire [`BCD_BIT_WIDTH-1:0] ssd_in; // input to 7-segment display decoder
wire mode;
//**************************************************************
// led
//**************************************************************
wire [15:0]led;
wire state_o;
wire led_1; // 1Hz divided clock
wire clk_100;
wire led_pb0, led_pb1; // LED display output (push button)
wire led_1pulse0, mode_1pulse; // LED display output (1 pulse)
wire tick;
//  assign led[15:1] = ( {dig2,dig1,dig0}==3'd0 )? 15'b111_1111_1111_1111 :15'b0;
// assign led[15:3] = ( {dig2,dig1,dig0}==3'd0 )? 13'b1_1111_1111_1111 :13'b0;
assign led[0] = (state_o == 1'b1)? 1'b1 :({dig1,dig0} == 2'd00)? 1'b1 :1'b0;
assign led[1] = led_1pulse0;
assign led[2] = mode;
assign led[3] = tick;
wire fsm_rst, fsm_ps;
//**************************************************************
// pulse
//**************************************************************

// Declare internal nodes

clock_generator U_cg(
  .clk(clk), // clock from crystal
  .rst_n(rst_n), // active low reset
  .clk_1(led_1), // generated 1 Hz clock
  .clk_100(clk_100) // generated 100 Hz clock
);
tick U_TICK(
    .clk(clk_100),
    .rst_n(rst_n),
    .initval(`DIV_BY_100_BIT_WIDTH'd0),
    .enable(state_o),
    .load(~state_o),
    // output
    .tick(tick)
);

// debounce circuit
debounce_circuit U_dc0(
  .clk(clk_100), // clock control
  .rst_n(rst_n), // reset
  .pb_in(in0), //push button input
  .pb_debounced(led_pb0) // debounced push button output
);
debounce_circuit U_dc1(
  .clk(clk_100), // clock control
  .rst_n(rst_n), // reset
  .pb_in(in1), //push button input
  .pb_debounced(led_pb1) // debounced push button output
);

press U_PP0(
    .mode_in(led_pb1),
    .short_press(fsm_ps), 
    .long_press(fsm_rst),
    .clk(clk_100),  // clock input
    .rst_n(rst_n) //active low reset
);
// 1 pulse generation circuit
one_pulse U_op0(
  .clk(clk_100),  // clock input
  .rst_n(rst_n), //active low reset
  .in_trig(led_pb0), // input trigger
  .out_pulse(led_1pulse0) //  output , use as SET pb into chg_mode of counter
);

lap_fsm U_lapfsm(
    .state_o(state_o),
    .in(led_1pulse0),
    .clk(clk_100),
    .rst_n(rst_n),
    .nowlap(mode)
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
  .state_o(state_o),
  .in0(fsm_rst), // input control
  .in1(fsm_ps),
  .rst(rst), // output rst stopwatch
  .count_enable(count_enable),  // if counter is enabled 
  .clk(clk_100), // global clock signal
  .rst_n(rst_n)  // low active reset
);

// stopwatch module
upcounter_4d U_UP(
  .nowlap(mode),
  .digit0(dig0),  // 2nd digit of the down counter
  .digit1(dig1),  // 1st digit of the down counter
  .digit2(dig2),
  .digit3(dig3),
  .clk(clk_100),  // global clock
  .rst(rst),
  .rst_n(rst_n),  // low active reset
  .en(count_enable&tick) // enable/disable for the stopwatch
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
  .in0(dig3), // 1st input
  .in1(dig2), // 2nd input
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