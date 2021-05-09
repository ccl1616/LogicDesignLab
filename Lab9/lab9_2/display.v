`timescale 1ns / 1ps
`include "global.v"
module display(
	input [7:0] AS_letter,
  	output reg [7:0]segs, // 14-segment segs output
);

// Combinatioanl Logic
always@(*)
  case(AS_letter)
    8'd99 : segs = 8'b0110_0011; // lower c
    8'd100 : num = 8'b1000_0101; // lower d
    8'd101 : num = 8'b0110_0001; // lower e
    8'd102 : num = 8'b0111_0001; // lower f
    8'd103 : num = 8'b0100_0001; // lower g
    8'd97 : num = 8'b0001_0001; // lower a
    8'd98 : num = 8'b1100_0001; // lowerb
    8'd67 : num = 8'b0110_0010; // cap c
    8'd68 : num = 8'b1000_0100; // cap d
    8'd69 : num = 8'b0110_0000; // cap e
    8'd70 : num = 8'b0111_0000; // cap f
    8'd71 : num = 8'b0100_0000; // cap g
    8'd65 : num = 8'b0001_0000; // cap a
    8'd66 : num = 8'b1100_0000; // lowerb
    default : num = 8'b0110_0011; // lower c
  endcase

endmodule
