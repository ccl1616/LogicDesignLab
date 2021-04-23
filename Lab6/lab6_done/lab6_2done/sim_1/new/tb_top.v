`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/17 21:46:50
// Design Name: 
// Module Name: tb_top
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
module tb_top();
reg switch,pbsec,pbmin,pbpause,pbstart,clk,rst_n;
wire [15:0]led;
wire [7:0]segs;
wire[1:0]ssd_ctl;

top U_TB(
    .switch(switch),
    .pbsec(pbsec),
    .pbmin(pbmin),
    .pbpause(pbpause),
    .pbstart(pbstart),
    .clk(clk),
    .rst_n(rst_n),
    .led(led),
    .segs(segs), // 7 segment display control
    .ssd_ctl(ssd_ctl) // scan control for 7-segment display
);

`define CYC 10
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end
wire clk_100;
assign clk_100 = U_TB.clk_100;
initial begin
    rst_n = 1'b0;
    switch = 1'b0;
    pbsec = 1'b0;
    pbmin = 1'b0;
    pbpause = 1'b0;
    pbstart = 1'b0;
    repeat(2)@(posedge clk);
    rst_n = 1'b1;
    repeat(2)@(posedge clk_100);
    switch = 1'b1;
    repeat(1)@(posedge clk_100);
    pbsec = 1'b1;
    repeat(10)@(posedge clk_100);
    switch = 1'b0;
    pbsec = 1'b0;
    repeat(5)@(posedge clk_100);
    pbstart = 1'b1;
    repeat(5)@(posedge clk_100);
    pbstart = 1'b0;
end
endmodule
