`timescale 1ns / 1ps
`define TRUE 1'b1
`define FALSE 1'b0
module tb_app();
reg clk,rst,newkey;
reg [8:0]last_change;
reg [511:0]key_down;
wire [7:0]AS_letter;
wire caps_lock;
cap_app U_TB(
    .clk(clk),
    .rst(rst),
    .last_change(last_change),
    .newkey(newkey),
    .key_down(key_down),
    .AS_letter(AS_letter),
    .caps_lock(caps_lock)
);
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end
initial begin
    rst = `TRUE;
    newkey = `FALSE;
    last_change = 9'b0;
    key_down = 512'd0;
    repeat(2)@(posedge clk); 
    rst = `FALSE;
    
    newkey = `TRUE;
    last_change = 9'h58;
    key_down[58] = `TRUE;
    repeat(2)@(posedge clk); 
    newkey = `FALSE;
    key_down[58] = `FALSE;
    repeat(2)@(posedge clk); 
    newkey = `FALSE;
    key_down[58] = `FALSE;
    repeat(2)@(posedge clk); 
    
    newkey = `TRUE;
    last_change = 9'h1C;
    key_down[9'h1C] = `TRUE;
    repeat(2)@(posedge clk); 
    newkey = `FALSE;
     key_down[9'h1C] = `FALSE;
end

endmodule
