`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/18 13:06:56
// Design Name: 
// Module Name: tick
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`include "global.v"
module tick(
    clk,
    rst_n,
    initval,
    enable,
    load,
    // output
    tick
);
input clk,rst_n,enable,load;
input [`DIV_BY_100_BIT_WIDTH-1:0]initval;
output wire tick;

reg  [`DIV_BY_100_BIT_WIDTH-1:0]count_next;
reg  [`DIV_BY_100_BIT_WIDTH-1:0]count;
always@* begin
    if(load)
        count_next = initval;
    else if(enable) 
        begin
            if(count == `DIV_BY_100-1)
                count_next = `DIV_BY_100_BIT_WIDTH'd0;
            else count_next = count+1;
        end
    else 
        count_next = count;
end

assign tick = (count == `DIV_BY_100-1)?1'b1:1'b0;

always@(posedge clk or negedge rst_n)
begin
    if(~rst_n) count <= `DIV_BY_100_BIT_WIDTH'd0;
    else count <= count_next;
end


endmodule
