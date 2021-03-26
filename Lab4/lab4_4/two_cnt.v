`timescale 1ns / 1ps
`include "global.v"
// 2 bcd digic up counter
module two_cnt(
    out0, // 4 bit output, for ones digit
    out1, // 4 bit output, for tens digit
    clk, 
    rst_n
);

output [`CNT_BIT_WIDTH-1 : 0]out0;
output [`CNT_BIT_WIDTH-1 : 0]out1;
input clk;
input rst_n;

wire carry_out0;
wire carry_out1;

upcnt Ud0(
    .q(out0), //output
    .carry_out(carry_out0), //output
    .carry_in(1),
    .clk(clk),
    .rst_n(rst_n) // low active reset
);

upcnt Ud1(
    .q(out1), //output
    .carry_out(carry_out1), //output
    .carry_in(carry_out0),
    .clk(clk),
    .rst_n(rst_n) // low active reset
);

endmodule

// one digit counter 0~9, with carry_in and carry_out
module upcnt(
    q, // 4-bit output
    carry_out, //output
    carry_in,
    clk,
    rst_n // low active reset
);
output [`CNT_BIT_WIDTH-1 : 0]q;
output carry_out;
input carry_in;
input clk;
input rst_n;

reg [`CNT_BIT_WIDTH-1 : 0]q;
reg [`CNT_BIT_WIDTH-1 : 0]q_tmp;
wire carry_out;

// combinational
always@* begin
    if( (carry_in == 1) & (q==`LIMIT) )
        q_tmp = `CNT_BIT_WIDTH'd0;
    else if( (carry_in == 1) )
        q_tmp = q+1;
    else q_tmp = q;
end

// comb deal with carry_out
assign carry_out = ( (carry_in == 1) & (q==`LIMIT) );

// sequential DFF
always@(posedge clk or negedge rst_n)
    if(~rst_n) q <= 0;
    else q <= q_tmp;

endmodule