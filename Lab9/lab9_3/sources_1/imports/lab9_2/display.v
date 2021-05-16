`timescale 1ns / 1ps
`include "global.v"
module display(
	input [3:0]value,
  	output reg [7:0]segs // 14-segment segs output
);

// Combinatioanl Logic
always@(*)
  case(value)
    4'd0 : segs = 8'b0110_0011; // lower c
    4'd1 : segs = 8'b1000_0101; // lower d
    4'd2 : segs = 8'b0110_0001; // lower e
    4'd3 : segs = 8'b0111_0001; // lower f
    4'd4 : segs = 8'b0100_0001; // lower g
    4'd5 : segs = 8'b0001_0001; // lower a
    4'd6 : segs = 8'b1100_0001; // lowerb
    4'd7 : segs = 8'b0110_0010; // cap c
    4'd8 : segs = 8'b1000_0100; // cap d
    4'd9 : segs = 8'b0110_0000; // cap e
    4'd10 : segs = 8'b0111_0000; // cap f
    4'd11 : segs = 8'b0100_0000; // cap g
    4'd12 : segs = 8'b0001_0000; // cap a
    4'd13 : segs = 8'b1100_0000; // lowerb
	4'd15 : segs = 8'b1111_1111; // none
    default : segs = 8'b0110_0011; // lower c
  endcase

endmodule