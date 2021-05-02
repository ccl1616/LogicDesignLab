`timescale 1ns / 1ps
`include "global.v"
module top8_2(
    inout wire PS2_DATA,
    inout wire PS2_CLK,
    input wire rst,
    input wire clk,
    output wire [3:0] ssd_ctl,
    output wire [7:0] segs,
    output wire [15:0] led
);

//**************************************************************
// Keyboard block
wire [511:0] key_down;
wire [8:0] last_change;
wire key_valid;
KeyboardDecoder U_KD(
	.key_down(key_down),
	.last_change(last_change),
	.key_valid(key_valid),
	.PS2_DATA(PS2_DATA),
	.PS2_CLK(PS2_CLK),
	.rst(rst),
	.clk(clk)
);

wire [3:0] char;
wire flag;
assign led[3:0] = char;
key2char U_K2C(
    .clk(clk),
    .last_change(last_change),
    .key_valid(key_valid),
    .char(char),
    .flag(flag)
);

//**************************************************************
// fsm block
wire [3:0] dig0,dig1,dig2,dig3;
fsm U_FSM(
    .clk(clk),
    .rst(rst),
    .last_change(last_change),
	.key_valid(key_valid),
    // BCDs
    .char(char), 
    .dig0(dig0),
    .dig1(dig1),
    .dig2(dig2),
    .dig3(dig3),
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
  .in0(dig0), // 1st input
  .in1(dig1), // 2nd input
  .in2(dig2), // 3rd input
  .in3(dig3),  // 4th input
  .ssd_ctl_en(ssd_ctl_en) // divided clock for scan control
);

// binary to 7-segment display decoder
display U_display(
  .segs(segs), // 7-segment display output
  .bin(ssd_in)  // BCD number input
);
endmodule