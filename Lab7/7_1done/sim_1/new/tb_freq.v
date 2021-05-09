`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/23 19:09:52
// Design Name: 
// Module Name: tb_freq
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module tb_freq();
reg clk,rst_n;
wire audio_mclk, audio_lrck, audio_sck,audio_sdin;
speaker UTB(
  clk, // clock from crystal
  rst_n, // active low reset
  audio_mclk, // master clock
  audio_lrck, // left-right clock
  audio_sck, // serial clock
  audio_sdin // serial audio data input
);
`define CYC 10
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin
    rst_n = 1'b0;
    repeat(4)@(posedge clk);
    rst_n = 1'b1;
end

endmodule
