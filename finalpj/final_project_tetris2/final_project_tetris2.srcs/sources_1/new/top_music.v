`timescale 1ns / 1ps

module my_music(
    input clk, rst,
    input slow_fast,
    output audio_mclk,
    output audio_lrck,
    output audio_sck,
    output audio_sdin
);

wire clk_1Hz;
wire clk_2Hz;
wire clk_4Hz;
wire clk_8Hz;
wire [21:0] note_division;
wire [15:0] audio_in_right, audio_in_left;

wire [15:0] amplitude_min,amplitude_max;
assign amplitude_max = 16'h0800;
assign amplitude_min = (~amplitude_max) + 1'b1;

clock_1Hz M0 (
    .clk_origin(clk),
    .rst(rst),
    .clk_1Hz(clk_1Hz)
);

clock_generator_ma M_Ma(
  .clk(clk), // clock from crystal
  .rst_n(~rst), // active low reset
  .clk_1( clk_1Hz_ ), // generated 1 Hz clock
  .clk_8(clk_8Hz) 
);

clkgen_2hz M_2hz(
  .clk(clk), // clock from crystal
  .rst_n(~rst), // active low reset
  .clk_2(clk_2Hz), // generated 2 Hz clock
  .clk_4(clk_4Hz) 
);
             
note_division M1 (
    .clk_1Hz(slow_fast?clk_8Hz:clk_4Hz),
    .rst(rst),
    .note_division(note_division)
);
    
note_gen M20(
  .clk(clk),
  .rst_n(~rst), // active low reset
  .note_div(note_division), // div for note generation
  .amplitude_min(amplitude_min),
  .amplitude_max(amplitude_max),
  .audio_left(audio_in_left), // left sound audio
  .audio_right(audio_in_right) // right sound audio
);
                    
speaker_control M3 (
    .clk(clk),
    .rst_n(~rst),
    .audio_in_right(audio_in_right),
    .audio_in_left(audio_in_left),
    .audio_mclk(audio_mclk),
    .audio_lrck(audio_lrck),
    .audio_sck(audio_sck),
    .audio_sdin(audio_sdin)
);

endmodule
