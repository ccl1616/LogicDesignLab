`timescale 1ns / 1ps
module tb_fsm();
reg clk,rst,key_valid;
reg [8:0]last_change;
reg [3:0]char;
wire [3:0]dig0,dig1,dig2,dig3;

fsm U_TB(
    .clk(clk),
    .rst(rst),
    .last_change(last_change),
    .key_valid(key_valid),
    // BCDs
    .char(char), 
    .dig0(dig0),
    .dig1(dig1),
    .dig2(dig2),
    .dig3(dig3)
);

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin
    rst = 1'b1;
    key_valid = 1'b0;
    last_change = 9'h00;
    char = 4'd0;
    repeat(4)@(posedge clk); 
    rst = 1'b0;
    #1;last_change = 9'h7D;
    char = 4'd9;
    key_valid = 1'b1;
    repeat(4)@(posedge clk);
    key_valid = 1'b0;
    repeat(4)@(posedge clk);
    key_valid = 1'b1; // release
    repeat(4)@(posedge clk);
    key_valid = 1'b0;
    repeat(4)@(posedge clk); #0.1;
    // press
    last_change = 9'h75;
    char = 4'd8;
    key_valid = 1'b1;
    repeat(4)@(posedge clk);
    key_valid = 1'b0;
    repeat(4)@(posedge clk);
    key_valid = 1'b1; // release
    repeat(4)@(posedge clk);
    key_valid = 1'b0;
end
endmodule
