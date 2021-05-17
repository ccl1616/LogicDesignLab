`timescale 1ns / 1ps

module note_division(
    input clk, rst,
    input switch,
    input [3:0] reference,
    output reg [21:0] note_division_left, note_division_right
);

always@(*)
  case(reference)
    4'd0 : note_division_left = 22'd191112; //mid Do
    4'd1 : note_division_left = 22'd170262; //re
    4'd2 : note_division_left = 22'd151686; //mi
    4'd3 : note_division_left = 22'd143172; //fa
    4'd4 : note_division_left = 22'd127552; //sol
    4'd5 : note_division_left = 22'd101238; //la
    4'd6 : note_division_left = 22'd101238; //si
    default : note_division_left = 22'd191112; //mid Do
  endcase

always@(*) begin
  default : note_division_right = 22'd191112; //mid Do
  if(switch) begin
    case(reference)
      4'd0 : note_division_right = 22'd151686; //mi
      4'd1 : note_division_right = 22'd143172; //fa
      4'd2 : note_division_right = 22'd127552; //sol
      4'd3 : note_division_right = 22'd101238; //la
      4'd4 : note_division_right = 22'd101238; //si
      4'd5 : note_division_right = 22'd113636; //la
      4'd6 : note_division_right = 22'd101238; //si
      default : note_division_right = 22'd191112; //mid Do
    endcase
  end
  else begin
      case(reference)
      4'd0 : note_division_right = 22'd191112; //mid Do
      4'd1 : note_division_right = 22'd170262; //re
      4'd2 : note_division_right = 22'd151686; //mi
      4'd3 : note_division_right = 22'd143172; //fa
      4'd4 : note_division_right = 22'd127552; //sol
      4'd5 : note_division_right = 22'd101238; //la
      4'd6 : note_division_right = 22'd101238; //si
      default : note_division_right = 22'd191112; //mid Do
  endcase
  end
end
endmodule