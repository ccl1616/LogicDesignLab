`timescale 1ns / 1ps

module FSM(
    input clk, rst,
    input [8:0] last_change,
    input newkey,
    output reg caps_lock
);
    
reg caps_lock_next;

always@(*)
  if(last_change == 9'h58)
    case( {caps_lock, newkey} )
      2'b00 : caps_lock_next = 1'b0;
      2'b01 : caps_lock_next = 1'b1; // turn on
      2'b10 : caps_lock_next = 1'b1;
      2'b11 : caps_lock_next = 1'b0; // turn off
      default : caps_lock_next = 1'b0;
    endcase
  else
    caps_lock_next = caps_lock;

always@(posedge clk or posedge rst)
  if(rst)
    caps_lock <= 1'b0;
  else
    caps_lock <= caps_lock_next;

endmodule
