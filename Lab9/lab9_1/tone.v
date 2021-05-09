`timescale 1ns / 1ps

module tone(
    input [3:0] value;
    output reg [21:0] N
);

always@(*)
  case(value)
    3'd0 : N = 22'd191112; //low Do
    3'd1 : N = 22'd170262;
    3'd2 : N = 22'd151686;
    3'd3 : N = 22'd143172;
    3'd4 : N = 22'd127552;
    3'd5 : N = 22'd113636;
    3'd6 : N = 22'd101238;
    3'd7 : N = 22'd95556; //high Do
    3'd8 : N = 22'd85131;
    3'd9 : N = 22'd75843;
    3'd10 : N = 22'd71586;
    3'd11 : N = 22'd63776;
    3'd12 : N = 22'd56818;
    3'd13 : N = 22'd50619;
    default : N = 22'd2;
  endcase

endmodule
