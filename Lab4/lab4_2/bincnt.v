// 4bit binary up counter
`timescale 1ns / 1ps
`include "global.v"
module bincnt(
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
    q_tmp = out + 1'b1;

// sequential
always@(posedge clk or negedge rst_n)
    if(~rst_n) out <= 0;
    else out <= q_tmp;

endmodule