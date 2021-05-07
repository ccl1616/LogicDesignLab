`timescale 1ns / 1ps

`include "global.v"
`define STATE_0 2'd0
`define STATE_1 2'd1
`define STATE_2 2'd2
`define BCD_NULL 4'd13
module fsm(
    newkey,
    state,
    clk,
    rst,
    last_change,
    key_valid,
    // BCDs
    char, 
    dig0,
    dig1,
    dig2,
    dig3
);
input clk;
input rst;
input [8:0] last_change;
input key_valid;

input [3:0]char;
output reg [3:0]dig0;
output reg [3:0]dig1;
output reg [3:0]dig2;
output reg [3:0]dig3;
output [1:0]state;
input newkey;
/*
reg [8:0] last_change_prev = 9'd0;
always@(posedge clk or posedge rst) begin
    if(rst) begin
        last_change_prev = 9'd0;
    end
    else if(key_valid) begin
        if(last_change_prev != last_change)
            last_change_prev <= last_change;
        else 
            last_change_prev <= last_change_prev;
    end
    else 
        last_change_prev <= last_change_prev;
end*/


reg [1:0]state,next_state;
// state transition
always@(*)begin
    case(state)
        `STATE_0: 
            begin
                if(newkey) begin
                    next_state = `STATE_1;
                end
                else begin
                    next_state = `STATE_0;
                end
            end
        `STATE_1:
            begin
                if(newkey) begin
                    next_state = `STATE_2;
                end 
                else begin
                    next_state = `STATE_1;
                end
            end
        `STATE_2:
            begin
                next_state = `STATE_2;
            end
        default:
            begin
                next_state = `STATE_0;
            end
            
    endcase
end

// output
wire [4:0]sum;
assign sum = dig0 + dig1;
always@(posedge clk) begin
    case(state)
        `STATE_0: begin
            if(newkey) begin
                dig0 <= char;
                dig1 <= `BCD_NULL;
                dig2 <= `BCD_NULL;
                dig3 <= `BCD_NULL;
            end
            else begin
                dig0 <= `BCD_NULL;
                dig1 <= `BCD_NULL;
                dig2 <= `BCD_NULL;
                dig3 <= `BCD_NULL;
            end
        end
        `STATE_1: begin
            if(newkey) begin
                dig0 <= dig0;
                dig1 <= char;
                dig2 <= `BCD_NULL;
                dig3 <= `BCD_NULL;
            end
            else begin
                dig0 <=  dig0;
                dig1 <= `BCD_NULL;
                dig2 <= `BCD_NULL;
                dig3 <= `BCD_NULL;
            end
        end
        `STATE_2: begin
            dig0 <=  dig0;
            dig1 <=  dig1;
            dig2 <= ( sum >=5'd10) ?`BCD_ONE:`BCD_NULL;
            dig3 <= ( sum >=5'd10) ?(sum-5'd10):(sum[3:0]);
        end
    endcase
end

// FSM state transition
always @(posedge clk or posedge rst)
  if (rst)
    state <= `STATE_0;
  else
    state <= next_state;

endmodule