`timescale 1ns / 1ps

module volume(
    clk, 
    rst,
    button_up, 
    button_down,
    amplitude_min,
    amplitude_max,
    volume //binary
);
input clk, rst;
input button_up, button_down;
output [15:0] amplitude_min;
output reg [15:0] amplitude_max;
output reg [3:0] volume;

reg [3:0] volume_tmp;
assign amplitude_min = 16'hB000;

always@(*)
  if(button_up && volume != 4'd15)
    volume_tmp = volume + 1'b1;
  else if(button_down && volume != 4'd0)
    volume_tmp = volume - 1'b1;
  else
    volume_tmp = volume;

always@(posedge clk or posedge rst)
  if(rst)
    volume <= 4'd0;
  else
    volume <= volume_tmp;
  
always@(*)
  case(volume)
    4'd0: amplitude_max = 16'd12800;
    4'd1: amplitude_max = 16'd5000;
    4'd2: amplitude_max = 16'd5000;
    4'd3: amplitude_max = 16'd6400;
    4'd4: amplitude_max = 16'd6400;
    4'd5: amplitude_max = 16'd7680;
    4'd6: amplitude_max = 16'd7680;
    4'd7: amplitude_max = 16'd8080;
    4'd8: amplitude_max = 16'd8080;
    4'd9: amplitude_max = 16'd8960;
    4'd10: amplitude_max = 16'd8960;
    4'd11: amplitude_max = 16'd10000;
    4'd12: amplitude_max = 16'd10000;
    4'd13: amplitude_max = 16'd11520;
    4'd14: amplitude_max = 16'd11520;
    4'd15: amplitude_max = 16'd12000;
    default: amplitude_max = 16'd12800;
  endcase

endmodule
