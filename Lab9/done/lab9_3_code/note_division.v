`timescale 1ns / 1ps

module note_division(
    input mode_switch,
    input [7:0] AS_letter,
    output reg [21:0] note_division_left,
    output reg [21:0] note_division_right
    );

always@(*)
  if(mode_switch)
    case(AS_letter)
      8'd99 : begin note_division_left = 22'd191571; note_division_right = 22'd151515; end  //mid Do Mi 
      8'd100 : begin note_division_left = 22'd170648; note_division_right = 22'd143266; end //mid Re Fa
      8'd101 : begin note_division_left = 22'd151515; note_division_right = 22'd127551; end //mid Mi Sol
      8'd102 : begin note_division_left = 22'd143266; note_division_right = 22'd113636; end //mid Fa La
      8'd103 : begin note_division_left = 22'd127551; note_division_right = 22'd101214; end //mid Sol Si
      8'd67 : begin note_division_left = 22'd95420; note_division_right = 22'd75758; end    //high Do Mi
      8'd68 : begin note_division_left = 22'd85034; note_division_right = 22'd71633; end    //high Re Fa
      8'd69 : begin note_division_left = 22'd75758; note_division_right = 22'd63775; end    //high Mi sol
      8'd70 : begin note_division_left = 22'd71633; note_division_right = 22'd56818; end    //high Fa La
      8'd71 : begin note_division_left = 22'd63775; note_division_right = 22'd50607; end    //high Sol Si
      default : begin note_division_left = 22'd0; note_division_right = 22'd0; end          //silent
    endcase
  else
    case(AS_letter)
      8'd99 : begin note_division_left = 22'd191571; note_division_right = 22'd191571; end  //mid Do
      8'd100 : begin note_division_left = 22'd170648; note_division_right = 22'd170648; end //mid Re
      8'd101 : begin note_division_left = 22'd151515; note_division_right = 22'd151515; end //mid Mi
      8'd102 : begin note_division_left = 22'd143266; note_division_right = 22'd143266; end //mid Fa
      8'd103 : begin note_division_left = 22'd127551; note_division_right = 22'd127551; end //mid Sol
      8'd97 : begin note_division_left = 22'd113636; note_division_right = 22'd113636; end  //mid La
      8'd98 : begin note_division_left = 22'd101214; note_division_right = 22'd101214; end  //mid Si
      8'd67 : begin note_division_left = 22'd95420; note_division_right = 22'd95420; end    //high Do
      8'd68 : begin note_division_left = 22'd85034; note_division_right = 22'd85034; end    //high Re
      8'd69 : begin note_division_left = 22'd75758; note_division_right = 22'd75758; end    //high Mi
      8'd70 : begin note_division_left = 22'd71633; note_division_right = 22'd71633; end    //high Fa
      8'd71 : begin note_division_left = 22'd63775; note_division_right = 22'd63775; end    //high Sol
      8'd65 : begin note_division_left = 22'd56818; note_division_right = 22'd56818; end    //high La
      8'd66 : begin note_division_left = 22'd50607; note_division_right = 22'd50608; end    //high Si
      default : begin note_division_left = 22'd0; note_division_right = 22'd0; end          //silent
    endcase

endmodule