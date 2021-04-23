`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/17 19:31:37
// Design Name: 
// Module Name: tb_upcnt
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


module tb_upcnt();
wire [3:0] digit0;
wire [3:0] digit1;
wire [3:0] digit2;
wire [3:0] digit3;

// input
reg pbsec,pbmin,clk,rst_n;
reg [2:0]state;

upcounter_4d U_tb(
    .pbsec(pbsec),
    .pbmin(pbmin),
    .state(state),
    .digit0(digit0),  // right most digit
    .digit1(digit1), 
    .digit2(digit2),
    .digit3(digit3),
    .clk(clk),  // global clock
    .rst_n(rst_n)  // low active reset
);

`define CYC 10
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin
    rst_n = 1'b0;
    pbsec = 1'b0;
    pbmin = 1'b0;
    state = 3'b000;
    repeat(1)@(posedge clk);
    rst_n = 1'b1;
    state = 3'b011;
    repeat(1)@(posedge clk);
    pbsec = 1'b1;
    repeat(5)@(posedge clk);
    pbsec = 1'b0;
    pbmin = 1'b1;
    repeat(5)@(posedge clk);
    pbmin = 1'b0;

end

endmodule
