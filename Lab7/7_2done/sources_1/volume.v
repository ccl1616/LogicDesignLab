`timescale 1ns / 1ps

module volume(
    clk, 
    rst_n,
    button_up, 
    button_down,
    amplitude_min,
    amplitude_max,
    volume //binary
);
input clk, rst_n;
input button_up, button_down;
output [15:0] amplitude_min;
output reg [15:0] amplitude_max;
output reg [3:0] volume;

reg [3:0] volume_tmp;
assign amplitude_min = (~amplitude_max) + 1'b1;

always@(*)
  if(button_up && volume != 4'd15)
    volume_tmp = volume + 1'b1;
  else if(button_down && volume != 4'd0)
    volume_tmp = volume - 1'b1;
  else
    volume_tmp = volume;

always@(posedge clk or negedge rst_n)
  if(~rst_n)
    volume <= 4'd0;
  else
    volume <= volume_tmp;
  
always@(*)
  case(volume)
    4'd0: amplitude_max = 16'h0000;
    4'd1: amplitude_max = 16'h0800;
    4'd2: amplitude_max = 16'h1000;
    4'd3: amplitude_max = 16'h1800;
    4'd4: amplitude_max = 16'h2000;
    4'd5: amplitude_max = 16'h2800;
    4'd6: amplitude_max = 16'h3000;
    4'd7: amplitude_max = 16'h3800;
    4'd8: amplitude_max = 16'h4000;
    4'd9: amplitude_max = 16'h4800;
    4'd10: amplitude_max = 16'h5000;
    4'd11: amplitude_max = 16'h5800;
    4'd12: amplitude_max = 16'h6000;
    4'd13: amplitude_max = 16'h6800;
    4'd14: amplitude_max = 16'h7000;
    4'd15: amplitude_max = 16'h7800;
    default: amplitude_max = 16'h0000;
  endcase
endmodule
