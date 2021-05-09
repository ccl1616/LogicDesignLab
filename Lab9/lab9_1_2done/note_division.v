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
    4'd0 : note_division = 22'd191571; //mid Do
    4'd1 : note_division = 22'd170648; //mid Re
    4'd2 : note_division = 22'd151515; //mid Mi
    4'd3 : note_division = 22'd143266; //mid Fa
    4'd4 : note_division = 22'd127551; //mid Sol
    4'd5 : note_division = 22'd113636; //mid La
    4'd6 : note_division = 22'd101214; //mid Si
    4'd7 : note_division = 22'd95420; //high Do
    4'd8 : note_division = 22'd85034; //high Re
    4'd9 : note_division = 22'd75758; //high Mi
    4'd10 : note_division = 22'd71633; //high Fa
    4'd11 : note_division = 22'd63775; //high Sol
    4'd12 : note_division = 22'd56818; //high La
    4'd13 : note_division = 22'd50607; //high Si
    default : note_division = 22'd191571; //mid Do
  endcase

endmodule