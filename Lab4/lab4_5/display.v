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
        4'd7: segs = `SS_7;
        4'd8: segs = `SS_8;
        4'd9: segs = `SS_9;

        4'd10: segs = `SS_A;
        4'd11: segs = `SS_B;
        4'd12: segs = `SS_C;
        4'd13: segs = `SS_D;
        4'd14: segs = `SS_E;
        4'd15: segs = `SS_F;
        default: segs = `SS_DEF;
    endcase
end
endmodule