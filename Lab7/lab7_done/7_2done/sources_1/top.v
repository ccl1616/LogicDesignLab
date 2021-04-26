`include "global.v"
module top(
    clk,
    rst_n,
    pb_l,
    pb_c,
    pb_r,
    pb_u,
    pb_d,
    audio_mclk, // master clock
    audio_lrck, // left-right clock
    audio_sck, // serial clock
    audio_sdin, // serial audio data input
    segs, // 7 segment display control
    ssd_ctl // scan control for 7-segment display
);
input clk,rst_n,pb_l,pb_c,pb_r,pb_u,pb_d;
output [`SSD_BIT_WIDTH-1:0] segs; // 7 segment display control
output [`SSD_DIGIT_NUM-1:0] ssd_ctl; // scan control for 7-segment display
wire [`SSD_SCAN_CTL_BIT_WIDTH-1:0] ssd_ctl_en;
wire [`BCD_BIT_WIDTH-1:0] ssd_in;
output audio_mclk; // master clock
output audio_lrck; // left-right clock
output audio_sck; // serial clock
output audio_sdin; // serial audio data input
wire [15:0] amplitude_min,amplitude_max;
wire [3:0]volume;
// bt
wire db_l,db_c,db_r,db_u,db_d; 
debounce_circuit U_DB_L(
  .clk(clk), // clock control
  .rst_n(rst_n), // reset
  .pb_in(pb_l), //push button input
  .pb_debounced(db_l) // debounced push button output
);
debounce_circuit U_DB_C(
  .clk(clk), // clock control
  .rst_n(rst_n), // reset
  .pb_in(pb_c), //push button input
  .pb_debounced(db_c) // debounced push button output
);
debounce_circuit U_DB_R(
  .clk(clk), // clock control
  .rst_n(rst_n), // reset
  .pb_in(pb_r), //push button input
  .pb_debounced(db_r) // debounced push button output
);
debounce_circuit U_DB_U(
  .clk(clk), // clock control
  .rst_n(rst_n), // reset
  .pb_in(pb_u), //push button input
  .pb_debounced(db_u) // debounced push button output
);
debounce_circuit U_DB_D(
  .clk(clk), // clock control
  .rst_n(rst_n), // reset
  .pb_in(pb_d), //push button input
  .pb_debounced(db_d) // debounced push button output
);
wire one_d, one_u;
one_pulse U_ONE_D(
  .clk(clk),  // clock input
  .rst_n(rst_n), //active low reset
  .in_trig(db_d), // input trigger
  .out_pulse(one_d) // output one pulse 
);
one_pulse U_ONE_U(
  .clk(clk),  // clock input
  .rst_n(rst_n), //active low reset
  .in_trig(db_u), // input trigger
  .out_pulse(one_u) // output one pulse 
);
// tone
wire [21:0]note_div;
tone U_TONE(
    .button_Do(db_l),
    .button_Re(db_c),
    .button_Mi(db_r),
    .N(note_div)
);
wire [15:0] audio_in_left,audio_in_right;
// Note generation
note_gen U_GEN(
  .clk(clk), // clock from crystal
  .rst_n(rst_n), // active low reset
  .note_div(note_div), // div for note generation
  .amplitude_min(amplitude_min),
  .amplitude_max(amplitude_max),
  .audio_left(audio_in_left), // left sound audio
  .audio_right(audio_in_right) // right sound audio
);

// Speaker controllor
speaker_control U_SC(
  .clk(clk),  // clock from the crystal
  .rst_n(rst_n),  // active low reset
  .audio_in_left(audio_in_left), // left channel audio data input
  .audio_in_right(audio_in_right), // right channel audio data input
  .audio_mclk(audio_mclk), // master clock
  .audio_lrck(audio_lrck), // left-right clock
  .audio_sck(audio_sck), // serial clock
  .audio_sdin(audio_sdin) // serial audio data input
);

volume U_VOL(
    .clk(clk), 
    .rst_n(rst_n),
    .button_up(one_u), 
    .button_down(one_d),
    .amplitude_min(amplitude_min),
    .amplitude_max(amplitude_max),
    .volume(volume) //binary
);
wire [3:0]bcd1,bcd0;
bin_bcd U_CONVERT(
    .bin(volume),
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
    .rst_n(rst_n) // low active reset
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