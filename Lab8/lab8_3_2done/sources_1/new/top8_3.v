`timescale 1ns / 1ps
`include "global.v"
module top8_3_2(
    inout wire PS2_DATA,
    inout wire PS2_CLK,
    input wire rst,
    input wire clk,
    output wire [3:0] ssd_ctl,
    output wire [7:0] segs,
    output wire [15:0] led
);
wire [2:0]state;
wire [3:0] char;
wire flag;
wire is_neg;
assign led[3:0] = char;
assign led[6:4] = state;
assign led[15] = is_neg;

//**************************************************************
// Keyboard block
wire [511:0] key_down;
wire [8:0] last_change;
wire key_valid;
wire key_down_op; // onepulse
KeyboardDecoder U_KD(
	.key_down(key_down),
	.last_change(last_change),
	.key_valid(key_valid),
	.PS2_DATA(PS2_DATA),
	.PS2_CLK(PS2_CLK),
	.rst(rst),
	.clk(clk)
);


key2char U_K2C(
    .clk(clk),
    .last_change(last_change),
    .key_valid(key_valid),
    .char(char),
    .flag(flag)
);

one_pulse U_OP0(
  .clk(clk),  // clock input
  .rst_n(~rst), //active low reset
  .in_trig(key_down[last_change]), // input trigger
  .out_pulse(key_down_op) //  output , use as SET pb into chg_mode of counter
);

wire [7:0]ascii;
last2ascii U_L2A(
    .clk(clk),
    .rst(rst),
    .last_change(last_change),
    .ascii(ascii)
);
//**************************************************************
// calculate app
wire [3:0] show0,show1,show2,show3;
calculator_app U_CAL(
    .clk(clk),
    .rst(rst),
    .ascii(ascii),
    .newkey(key_down_op),
    .show0(show0),
    .show1(show1),
    .show2(show2),
    .show3(show3),
    .state(state),
    .is_neg(is_neg)
);

//**************************************************************
// Display block
wire clk_d;
wire [1:0] ssd_ctl_en;
wire [3:0] ssd_in;
freqdiv27 U_FD(
    .clk_out(clk_d), // divided clock
    .clk_ctl(ssd_ctl_en), // divided clock for scan control 
    .clk(clk), // clock from the crystal
    .rst_n(~rst) // low active reset
);
scan_ctl U_SCAN(
  .ssd_ctl(ssd_ctl), // ssd display control signal 
  .ssd_in(ssd_in), // output to ssd display
  .in0(show3), // 1st input
  .in1(show2), // 2nd input
  .in2(show1), // 3rd input
  .in3(show0),  // 4th input
  .ssd_ctl_en(ssd_ctl_en) // divided clock for scan control
);

// binary to 7-segment display decoder
display U_display(
  .segs(segs), // 7-segment display output
  .bin(ssd_in)  // BCD number input
);
endmodule