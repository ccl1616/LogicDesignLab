`timescale 1ns / 1ps

module top9_3(
    inout wire PS2_DATA,
	inout wire PS2_CLK,
	input wire rst,
    input wire mode,
	input wire clk,
	output wire [15:0] led,
	output [7:0] segs, // 7 segment display control
    output [3:0] ssd_ctl, // scan control for 7-segment display
	output audio_mclk,
    output audio_lrclk,
    output audio_sclk,
    output audio_sdin
);
wire caps_lock;
wire [7:0]AS_letter;
wire [3:0] num;
assign led[6:0] = AS_letter;
assign led[15] = caps_lock;
assign led[14:11] = num;
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
wire [21:0] note_division_left, note_division_right;
wire [15:0] audio_in_right, audio_in_left;

as2num M_AS(
	.AS_letter(AS_letter),
    .num(num)
);

note_division M1 (
    .clk(clk),
    .rst(rst),
    .switch(mode),
	.reference(num),
    .note_division_left(note_division_left),
    .note_division_right(note_division_right),
);
                 
note_generation M2 (
    .clk(clk),
    .rst(rst),
    .note_division_left(note_division_left),
    .note_division_right(note_division_right),
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
  .in0(4'd15), // 1st input
  .in1(4'd15), // 2nd input
  .in2(4'd15), // 3rd input
  .in3(num),  // 4th input
  .ssd_ctl_en(ssd_ctl_en) // divided clock for scan control
);

// binary to 7-segment display decoder
display U_display(
  .segs(segs), // 7-segment display output
  .value(num)  // num 0~13
);
endmodule