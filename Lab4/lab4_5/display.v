// 4bit binary to 7-seg
`timescale 1ns / 1ps
`include "global.v"
module display(
    segs, // 14-segment segs output
    bin  // binary input
);
output [`SSD_BIT_WIDTH-1:0] segs;  
input [3:0] bin;
reg [`SSD_BIT_WIDTH-1:0] segs;

always @(*) begin 
    case (bin)
        4'd0: segs = `SS_0;
        4'd1: segs = `SS_1;
        4'd2: segs = `SS_2;
        4'd3: segs = `SS_3;
        4'd4: segs = `SS_4;
        4'd5: segs = `SS_5;
        4'd6: segs = `SS_6;
        default: segs = `SS_DEF;
    endcase
end
endmodule