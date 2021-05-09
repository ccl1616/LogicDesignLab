`timescale 1ns / 1ps
`include "global.v"
module bin_bcd(
    bin,
    bcd1,
    bcd0
);
input [3:0]bin;
output reg [3:0] bcd1,bcd0;

always@(*)
    case (bin)
        4'd0: {bcd1,bcd0} = {`BCD_ZERO,`BCD_ZERO};
        4'd1: {bcd1,bcd0} = {`BCD_ZERO,`BCD_ONE};
        4'd2: {bcd1,bcd0} = {`BCD_ZERO,`BCD_TWO};
        4'd3: {bcd1,bcd0} = {`BCD_ZERO,`BCD_THREE};
        4'd4: {bcd1,bcd0} = {`BCD_ZERO,`BCD_FOUR};
        4'd5: {bcd1,bcd0} = {`BCD_ZERO,`BCD_FIVE};
        4'd6: {bcd1,bcd0} = {`BCD_ZERO,`BCD_SIX};
        4'd7: {bcd1,bcd0} = {`BCD_ZERO,`BCD_SEVEN};
        4'd8: {bcd1,bcd0} = {`BCD_ZERO,`BCD_EIGHT};
        4'd9: {bcd1,bcd0} = {`BCD_ZERO,`BCD_NINE};
        4'd10: {bcd1,bcd0} = {`BCD_ONE,`BCD_ZERO};
        4'd11: {bcd1,bcd0} = {`BCD_ONE,`BCD_ONE};
        4'd12: {bcd1,bcd0} = {`BCD_ONE,`BCD_TWO};
        4'd13: {bcd1,bcd0} = {`BCD_ONE,`BCD_THREE};
        4'd14: {bcd1,bcd0} = {`BCD_ONE,`BCD_FOUR};
        4'd15: {bcd1,bcd0} = {`BCD_ONE,`BCD_FIVE};
        default: {bcd1,bcd0} = {`BCD_ZERO,`BCD_ZERO};
     endcase

endmodule
