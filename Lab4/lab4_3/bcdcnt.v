// bcd counter 0~9
`timescale 1ns / 1ps
`include "global.v"
module bcdcnt(
    out, //output
    clk,
    rst_n
);

output [`CNT_BIT_WIDTH-1 : 0]out;
input clk;
input rst_n;

reg [`CNT_BIT_WIDTH-1 : 0]out;
reg [`CNT_BIT_WIDTH-1 : 0]q_tmp;

// combinational
always@*
    if(out == 4'd9) q_tmp = 4'd0;
    else q_tmp = out + 1'b1;

// sequential
always@(posedge clk or negedge rst_n)
    if(~rst_n) out <= 0;
    else out <= q_tmp;

endmodule