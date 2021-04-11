`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/10 20:42:57
// Design Name: 
// Module Name: tb_mode
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

// `include "global.v"
module tb_mode();
wire [7:0] segs; // 7 segment display control
wire [3:0] ssd_ctl; // scan control for 7-segment display
wire [15:0]led;
reg clk; // clock
reg rst_n; // low active reset
reg in0; 
reg in1;

stopwatch U_tb(
    .led(led),
    .segs(segs), // 7 segment display control
    .ssd_ctl(ssd_ctl), // scan control for 7-segment display
    .clk(clk), // clock
    .rst_n(rst_n), // low active reset
    .in0(in0),
    .in1(in1)
);
`define CYC 10
wire clk_100;
assign clk_100 = U_tb.clk_100;
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin
    rst_n = 1'b0;
    in0 = 1'd0;
    in1 = 1'd0;
    # (`CYC*2);
    // rst
    rst_n = 1'b1;
    in0 = 1'd1; in1 = 1'd0;
    repeat(5) @(posedge clk_100);
        in0 = 1'd0; in1 = 1'd0;
    repeat(5) @(posedge clk_100);
    in0 = 1'd0; in1 = 1'd1;
    repeat(5) @(posedge clk_100);
        in0 = 1'd0; in1 = 1'd0;
    repeat(5) @(posedge clk_100);
    in0 = 1'd0; in1 = 1'd1;
    repeat(5) @(posedge clk_100);
    in0 = 1'd1; in1 = 1'd0;
    repeat(5) @(posedge clk_100);
    in0 = 1'd0; in1 = 1'd0;
end

endmodule
