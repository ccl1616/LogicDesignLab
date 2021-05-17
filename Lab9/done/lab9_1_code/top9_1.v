`timescale 1ns / 1ps

module top9_1(
    input clk, rst,
    output audio_mclk,
    output audio_lrclk,
    output audio_sclk,
    output audio_sdin
);

wire clk_1Hz;
wire [21:0] note_division;
wire [15:0] audio_in_right, audio_in_left;

Clock_1Hz M0 (
    .clk_origin(clk),
    .rst(rst),
    .clk_1Hz(clk_1Hz)
);
             
note_division M1 (
    .clk_1Hz(clk_1Hz),
    .rst(rst),
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
    .rst_n(~rst),
    .audio_in_right(audio_in_right),
    .audio_in_left(audio_in_left),
    .audio_mclk(audio_mclk),
    .audio_lrck(audio_lrclk),
    .audio_sck(audio_sclk),
    .audio_sdin(audio_sdin)
);

endmodule
