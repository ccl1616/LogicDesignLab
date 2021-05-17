`timescale 1ns / 1ps

module top9_2(
    inout wire PS2_DATA,
	inout wire PS2_CLK,
	input wire rst,
	input wire clk,
	output wire [15:0] led,
	output [7:0] segs, // 7 segment display control
    output [3:0] ssd_ctl // scan control for 7-segment display
	output audio_mclk,
    output audio_lrclk,
    output audio_sclk,
    output audio_sdin
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
// output AS
cap_app U_APP(
    .rst(rst),
	.clk(clk),
    .last_change(last_change),
    .newkey(key_down_op),
    .key_down(key_down),
    .AS_letter(AS_letter),
    .caps_lock(caps_lock)
);

//**************************************************************
// AS 2 speaker
wire [21:0] note_division;
wire [15:0] audio_in_right, audio_in_left;
wire [3:0] num;
as2num M_AS(
	.AS_letter(AS_letter),
    .num(num)
);

note_division M1 (
    .clk(clk),
    .rst(rst),
	.reference(reference)
    .note_division(note_division)
);
                 
note_generation M2 (
    .clk(clk),
    .rst(rst),
    .note_division(note_division),
    .audio_right(audio_in_right),
    .audio_left(audio_in_left)
);
                    
speaker_control M3 (
    .clk(clk),
    .rst(rst),
    .audio_in_right(audio_in_right),
    .audio_in_left(audio_in_left),
    .audio_mclk(audio_mclk),
    .audio_lrclk(audio_lrclk),
    .audio_sclk(audio_sclk),
    .audio_sdin(audio_sdin)
);

endmodule