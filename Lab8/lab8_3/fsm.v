`timescale 1ns / 1ps

`include "global.v"
`define STATE_0 3'd0
`define STATE_1 3'd1
`define STATE_2 3'd2
`define STATE_3 3'd3 // middle
`define STATE_4 3'd4
`define STATE_5 3'd5
`define STATE_6 3'd6 // final

`define BCD_NULL 4'd13
module fsm(
    newkey,
    clk,
    rst,
    is_number,
    is_enter,
    state,
    sel
);
input newkey;
input clk;
input rst;
output [2:0]state; // careful for digits!
output [2:0]sel;

reg [2:0]state,next_state;
reg [2:0]sel,sel_next;

// state transition
always@(*)begin
    case(state)
        `STATE_0: 
            begin
                if(newkey&is_number) begin
                    next_state = `STATE_1;
                end
                else begin
                    next_state = `STATE_0;
                end
            end
        `STATE_1:
            begin
                if(newkey&is_number) begin
                    next_state = `STATE_2;
                end 
                else if(newkey&(~is_number)) begin
                    next_state = `STATE_3;
                end
                else begin
                    next_state = `STATE_1;
                end
            end
        `STATE_2:
            begin
                if(newkey) begin
                    next_state = `STATE_3;
                end
                else begin
                    next_state = `STATE_2;
                end
            end
        `STATE_3:
            begin
                if(newkey&is_number) begin
                    next_state = `STATE_4;
                end 
                else begin
                    next_state = `STATE_3;
                end
            end
        `STATE_4:
            begin
                if(newkey&is_number) begin
                    next_state = `STATE_5;
                end 
                else if(newkey&(~is_number)) begin
                    next_state = `STATE_6;
                end
                else begin
                    next_state = `STATE_4;
                end
            end
        `STATE_5:
            begin
                if(newkey&is_number) begin
                    next_state = `STATE_6;
                end 
                else begin
                    next_state = `STATE_5;
                end
            end
        `STATE_6:
            begin
                if(newkey) begin
                    next_state = `STATE_0;
                end 
                else begin
                    next_state = `STATE_6;
                end
            end
        default: 
            next_state = `STATE_0;
            
    endcase
end

// output
wire [4:0]sum;
assign sum = dig0 + dig1;
always@(*) begin
    case(state)
        `STATE_0: 
            sel_next = 3'd0;
        `STATE_1:
            sel_next = 3'd1;
        `STATE_2:
            sel_next = 3'd2;
        `STATE_3:
            sel_next = 3'd3;
        `STATE_4:
            sel_next = 3'd4;
        `STATE_5:
            sel_next = 3'd5;
        `STATE_6:
            sel_next = 3'd6;
        default: 
            sel_next = 3'd0;
            
    endcase
end

// FSM state flipflop
always @(posedge clk or posedge rst)
  if (rst) begin
    state <= `STATE_0;
    sel <= 3'd0;
  end
  else begin
    state <= next_state;
    sel <= sel_next;
  end
endmodule