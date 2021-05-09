`include "global.v"
module top9_1(
    clk,
    rst,
    audio_mclk, // master clock
    audio_lrck, // left-right clock
    audio_sck, // serial clock
    audio_sdin, // serial audio data input
    segs, // 7 segment display control
    ssd_ctl // scan control for 7-segment display
);
input clk,rst;
output [`SSD_BIT_WIDTH-1:0] segs; // 7 segment display control
output [`SSD_DIGIT_NUM-1:0] ssd_ctl; // scan control for 7-segment display
wire [`SSD_SCAN_CTL_BIT_WIDTH-1:0] ssd_ctl_en;
wire [`BCD_BIT_WIDTH-1:0] ssd_in;
output audio_mclk; // master clock
output audio_lrck; // left-right clock
output audio_sck; // serial clock
output audio_sdin; // serial audio data input

// ************************************************
// 1 sec clock
wire clk_1, clk_100;
clock_generator U_cg(
  .clk(clk), // clock from crystal
  .rst_n(~rst), // active low reset
  .clk_1(clk_1), // generated 1 Hz clock
  .clk_100(clk_100) // generated 100 Hz clock
);

// ************************************************
// pre-speaker
wire [3:0]value; //0~13 binary number
wire carry_out;
upcnt U_CNT(
    .q(value), 
    .carry_in(1'b1),
    .carry_out(carry_out), 
    .init_val(4'd0),
    .limit(4'd13),
    .clk(clk_1),
    .rst_n(~rst) // low active reset
);

// ************************************************
// speaker module
wire [21:0]note_div;
tone U_TONE(
    .value(value),
    .N(note_div)
);
wire [15:0] audio_in_left,audio_in_right;
// Note generation
note_gen U_GEN(
  .clk(clk), // clock from crystal
  .rst_n(~rst), // active low reset
  .note_div(note_div), // div for note generation
  .audio_left(audio_in_left), // left sound audio
  .audio_right(audio_in_right) // right sound audio
);

// Speaker controllor
speaker_control U_SC(
  .clk(clk),  // clock from the crystal
  .rst_n(~rst),  // active low reset
  .audio_in_left(audio_in_left), // left channel audio data input
  .audio_in_right(audio_in_right), // right channel audio data input
  .audio_mclk(audio_mclk), // master clock
  .audio_lrck(audio_lrck), // left-right clock
  .audio_sck(audio_sck), // serial clock
  .audio_sdin(audio_sdin) // serial audio data input
);
// ************************************************

wire [3:0]bcd1,bcd0;
bin_bcd U_CONVERT(
    .bin(value),
    .bcd1(bcd1),
    .bcd0(bcd0)
);
//**************************************************************
// Display block
wire clk_d;
freqdiv27 U_FD(
    .clk_out(clk_d), // divided clock
    .clk_ctl(ssd_ctl_en), // divided clock for scan control 
    .clk(clk), // clock from the crystal
    .rst_n(~rst) // low active reset
);
scan_ctl U_SCAN(
  .ssd_ctl(ssd_ctl), // ssd display control signal 
  .ssd_in(ssd_in), // output to ssd display
  .in0(`BCD_ZERO), // 1st input
  .in1(`BCD_ZERO), // 2nd input
  .in2(bcd1), // 3rd input
  .in3(bcd0),  // 4th input
  .ssd_ctl_en(ssd_ctl_en) // divided clock for scan control
);

// binary to 7-segment display decoder
display U_display(
  .segs(segs), // 7-segment display output
  .bin(ssd_in)  // BCD number input
);
endmodule