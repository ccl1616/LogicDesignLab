`timescale 1ns / 1ps

module tone(
    input button_Do, button_Re, button_Mi,
    output reg [21:0] N
);

always@(*)
  case({button_Do, button_Re, button_Mi})
    3'b001 : N = 22'd151515;
    3'b010 : N = 22'd170648;
    3'b100 : N = 22'd191571;
    default : N = 22'd191571;
  endcase

endmodule
