`timescale 1ns / 1ps

`define STATE_ONE 1'b1
`define STATE_ZERO 1'b0
module lap_fsm(
    state_o,
    in,
    clk,
    rst_n,
    nowlap 
);
input in;
input clk;
input rst_n;
input state_o;
output nowlap;

reg state;
reg next_state;
reg nowlap;

always@* 
    case(state)
    `STATE_ZERO: 
    if(state_o == 1'b1 && in == 1'b1)begin
        nowlap = 1'b1;
        next_state = `STATE_ONE;
    end
    else begin
        nowlap = 1'b0;
        next_state = `STATE_ZERO;
    end
    `STATE_ONE: 
    if(state_o == 1'b1 && in == 1'b1)begin
        nowlap = 1'b0;
        next_state = `STATE_ZERO;
    end
    else begin
        nowlap = 1'b1;
        next_state = `STATE_ONE;
    end
endcase

// FSM
always @(posedge clk or negedge rst_n)
    if(~rst_n)
        state <= `STATE_ZERO;
    else
        state <= next_state;    

endmodule
