`timescale 1ns / 1ps
`include "global.v"
module display(
  segs, // 14-segment segs output
  bin  // binary input
);
output [`SSD_BIT_WIDTH-1:0] segs; // 7-segment segs out [7:0]
input [`BCD_BIT_WIDTH-1:0] bin; // binary input [3:0]

reg [`SSD_BIT_WIDTH-1:0] segs; 

// Combinatioanl Logic
always @*
  case (bin)
    4'd0: segs = `SSD_ZERO;
	4'd1: segs = `SSD_ONE;
	4'd2: segs = `SSD_TWO;
	4'd3: segs = `SSD_THREE;
	4'd4: segs = `SSD_FOUR;
	4'd5: segs = `SSD_FIVE;
	4'd6: segs = `SSD_SIX;
	4'd7: segs = `SSD_SEVEN;
	4'd8: segs = `SSD_EIGHT;
	4'd9: segs = `SSD_NINE;
	4'd10: segs = `SSD_A;
	4'd11: segs = `SSD_S;
	4'd12: segs = `SSD_M;
	4'd13: segs = `SSD_ENTER;
	default: segs = `SSD_ZERO;
  endcase
  
endmodule
