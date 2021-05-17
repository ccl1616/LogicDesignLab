`timescale 1ns / 1ps

module note_division(
    input clk_1Hz, rst,
    output reg [21:0] note_division
    );

reg [3:0] reference;

always@(posedge clk_1Hz or posedge rst)
  if(rst)
    reference <= 4'd0;
  else if(reference == 4'd13)
    reference <= 4'd0;
  else
    reference <= reference + 1'b1;

always@(*)
  case(reference)
    4'd0 : note_division = 22'd191112; //mid Do
    4'd1 : note_division = 22'd170262;
    4'd2 : note_division = 22'd151686;
    4'd3 : note_division = 22'd143172;
    4'd4 : note_division = 22'd127552;
    4'd5 : note_division = 22'd113636;
    4'd6 : note_division = 22'd101238;
    4'd7 : note_division = 22'd95556; //high Do
    4'd8 : note_division = 22'd85131;
    4'd9 : note_division = 22'd75843;
    4'd10 : note_division = 22'd71586;
    4'd11 : note_division = 22'd63776;
    4'd12 : note_division = 22'd56818;
    4'd13 : note_division = 22'd50619;
    default : note_division = 22'd191112; //mid Do
  endcase

endmodule