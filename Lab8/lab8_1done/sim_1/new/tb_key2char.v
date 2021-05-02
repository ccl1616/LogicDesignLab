`timescale 1ns / 1ps

module tb_key2char();
reg clk;
reg [8:0]last_change;
reg key_valid;
wire [3:0]char;
wire flag;

key2char U_TB(
    .clk(clk),
    .last_change(last_change),
    .key_valid(key_valid),
    .char(char),
    .flag(flag)
);

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin
    last_change = 9'h70;
    key_valid = 1'b0;
    repeat(4)@(posedge clk);
    key_valid = 1'b1;
    repeat(4)@(posedge clk);
    key_valid = 1'b0;
    repeat(4)@(posedge clk);
    key_valid = 1'b1;
    repeat(4)@(posedge clk);
    key_valid = 1'b0;
    repeat(4)@(posedge clk);
    last_change = 9'h72;
    key_valid = 1'b1;
    repeat(4)@(posedge clk);
    key_valid = 1'b0;
    repeat(4)@(posedge clk);
    key_valid = 1'b1;
    repeat(4)@(posedge clk);
    key_valid = 1'b0;
    repeat(4)@(posedge clk);
    key_valid = 1'b1;
    last_change = 9'h5A;
    repeat(4)@(posedge clk);
    key_valid = 1'b0;
    repeat(4)@(posedge clk);
    key_valid = 1'b1;
    repeat(4)@(posedge clk);
    key_valid = 1'b0;
end
endmodule
