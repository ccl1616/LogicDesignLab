module top(
    clk,
    rst_n,
    pb_l,
    pb_c,
    pb_r,
    audio_mclk, // master clock
    audio_lrck, // left-right clock
    audio_sck, // serial clock
    audio_sdin // serial audio data input
);
input clk,rst_n,pb_l,pb_c,pb_r;
output audio_mclk; // master clock
output audio_lrck; // left-right clock
output audio_sck; // serial clock
output audio_sdin; // serial audio data input

// bt
wire db_l,db_c,db_r; 
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
// tone
wire [21:0]note_div;
tone U_TONE(
    .button_Do(db_l),
    .button_Re(db_c),
    .button_Mi(db_r),
    .N(note_div)
);

// Note generation
note_gen U_GEN(
  .clk(clk), // clock from crystal
  .rst_n(rst_n), // active low reset
  .note_div(note_div), // div for note generation
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

endmodule