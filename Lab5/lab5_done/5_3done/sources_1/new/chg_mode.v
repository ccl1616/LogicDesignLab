`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/10 20:24:28
// Design Name: 
// Module Name: chg_mode
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description:  change mode FSM
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`define STATE_ONE 1'b1
`define STATE_ZERO 1'b0
module chg_mode(
    state_o,
    in,
    clk,
    rst_n,
    mode
);
input in;
input clk;
input rst_n;
input state_o;
output mode;
reg state;
reg next_state;
reg mode;
always@* 
    case(state)
    `STATE_ZERO: 
    if(state_o == 1'b0 && in == 1'b1)begin
        mode = 1'b1;
        next_state = `STATE_ONE;
    end
    else begin
        mode = 1'b0;
        next_state = `STATE_ZERO;
    end
    `STATE_ONE: 
    if(state_o == 1'b0 && in == 1'b1)begin
        mode = 1'b0;
        next_state = `STATE_ZERO;
    end
    else begin
        mode = 1'b1;
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
