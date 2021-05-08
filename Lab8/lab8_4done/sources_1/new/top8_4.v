`timescale 1ns / 1ps

module top8_4(
    inout wire PS2_DATA,
	inout wire PS2_CLK,
	input wire rst,
	input wire clk,
	output wire [15:0] led
);
wire caps_lock;
wire [7:0]AS_letter;
assign led[6:0] = AS_letter;
assign led[15] = caps_lock;
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

one_pulse U_OP0(
  .clk(clk),  // clock input
  .rst_n(~rst), //active low reset
  .in_trig(key_down[last_change]), // input trigger
  .out_pulse(key_down_op) 
);

//**************************************************************
// main
cap_app U_APP(
    .rst(rst),
	.clk(clk),
    .last_change(last_change),
    .newkey(key_down_op),
    .key_down(key_down),
    .AS_letter(AS_letter),
    .caps_lock(caps_lock)
);


endmodule