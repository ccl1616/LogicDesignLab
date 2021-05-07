`timescale 1ns / 1ps

module identify(
    input clk, rst,
    input [8:0] last_change,
    output reg is_add, is_subtract, is_multiple, is_enter, is_number
    );

reg is_add_tmp, is_subtract_tmp, is_multiple_tmp, is_enter_tmp, is_number_tmp;

always@(*)
  case(last_change)
    9'h5A : begin is_enter_tmp = 1'b1; is_add_tmp = is_add; is_subtract_tmp = is_subtract; is_multiple_tmp = is_multiple; is_number_tmp = is_number; end
    9'h79 : begin is_enter_tmp = 1'b0; is_add_tmp = 1'b1; is_subtract_tmp = 1'b0; is_multiple_tmp = 1'b0; is_number_tmp = 1'b0; end
    9'h7B : begin is_enter_tmp = 1'b0; is_add_tmp = 1'b0; is_subtract_tmp = 1'b1; is_multiple_tmp = 1'b0; is_number_tmp = 1'b0; end
    9'h7C : begin is_enter_tmp = 1'b0; is_add_tmp = 1'b0; is_subtract_tmp = 1'b0; is_multiple_tmp = 1'b1; is_number_tmp = 1'b0; end
    9'h70 : begin is_enter_tmp = 1'b0; is_add_tmp = 1'b0; is_subtract_tmp = 1'b0; is_multiple_tmp = 1'b0; is_number_tmp = 1'b1; end
    9'h69 : begin is_enter_tmp = 1'b0; is_add_tmp = 1'b0; is_subtract_tmp = 1'b0; is_multiple_tmp = 1'b0; is_number_tmp = 1'b1; end
    9'h72 : begin is_enter_tmp = 1'b0; is_add_tmp = 1'b0; is_subtract_tmp = 1'b0; is_multiple_tmp = 1'b0; is_number_tmp = 1'b1; end
    9'h7A : begin is_enter_tmp = 1'b0; is_add_tmp = 1'b0; is_subtract_tmp = 1'b0; is_multiple_tmp = 1'b0; is_number_tmp = 1'b1; end
    9'h6B : begin is_enter_tmp = 1'b0; is_add_tmp = 1'b0; is_subtract_tmp = 1'b0; is_multiple_tmp = 1'b0; is_number_tmp = 1'b1; end
    9'h73 : begin is_enter_tmp = 1'b0; is_add_tmp = 1'b0; is_subtract_tmp = 1'b0; is_multiple_tmp = 1'b0; is_number_tmp = 1'b1; end
    9'h74 : begin is_enter_tmp = 1'b0; is_add_tmp = 1'b0; is_subtract_tmp = 1'b0; is_multiple_tmp = 1'b0; is_number_tmp = 1'b1; end
    9'h6C : begin is_enter_tmp = 1'b0; is_add_tmp = 1'b0; is_subtract_tmp = 1'b0; is_multiple_tmp = 1'b0; is_number_tmp = 1'b1; end
    9'h75 : begin is_enter_tmp = 1'b0; is_add_tmp = 1'b0; is_subtract_tmp = 1'b0; is_multiple_tmp = 1'b0; is_number_tmp = 1'b1; end
    9'h7D : begin is_enter_tmp = 1'b0; is_add_tmp = 1'b0; is_subtract_tmp = 1'b0; is_multiple_tmp = 1'b0; is_number_tmp = 1'b1; end
    default : {is_add_tmp, is_subtract_tmp, is_multiple_tmp, is_enter_tmp, is_number_tmp} = 5'b00000;
  endcase

always@(posedge clk or posedge rst)
  if(rst)
    {is_add, is_subtract, is_multiple, is_enter, is_number} = 5'b00000;
  else
    {is_add, is_subtract, is_multiple, is_enter, is_number} = {is_add_tmp, is_subtract_tmp, is_multiple_tmp, is_enter_tmp, is_number_tmp};

endmodule
