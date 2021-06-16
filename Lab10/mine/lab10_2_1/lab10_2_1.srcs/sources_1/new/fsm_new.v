`timescale 1ns / 1ps

// `include "global.v"
`define STATE_0 3'd0
`define STATE_1 3'd1
`define STATE_2 3'd2

`define BCD_NULL 4'd13
module fsm_new(
    newkey,
    clk,
    rst,
    is_number,
    is_enter,
    state
);
input newkey;
input clk;
input rst;
output [2:0]state; 
input is_number, is_enter;
reg [2:0]state,next_state;

// state transition
always@(*)begin
    case(state)
        `STATE_0: 
            begin
                if(newkey&(~is_number) ) begin
                    next_state = `STATE_1;
                end
                else begin
                    next_state = `STATE_0;
                end
            end
        `STATE_1:
            begin
                if(newkey&is_enter) begin
                    next_state = `STATE_2;
                end
                else begin
                    next_state = `STATE_1;
                end
            end
        `STATE_2:
            next_state = `STATE_2;
        
        default: 
            next_state = `STATE_0;
            
    endcase
end

// FSM state flipflop
always @(posedge clk or posedge rst)
  if (rst) begin
    state <= `STATE_0;
  end
  else begin
    state <= next_state;
  end
endmodule