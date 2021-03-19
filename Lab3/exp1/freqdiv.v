// 2^27 frequency divider

`define FREQ_BIT 27
module freqdiv(
    clk_out,
    clk,
    rst_n;
);

output clk_out; //devided output
input clk;
input rst_n; //active low reset

reg clk_out;
reg [`FREQ_BIT-2 : 0] cnt; //remainder 25:0
reg [`FREQ_BIT-1 : 0] cnt_tmp; //input to DFF, 26:0

// combinational
always @*
    cnt_tmp = {clk_out, cnt} + 1'b1;

// sequential
always @(posedge clk or negedge rst_n)
    if(~rst_n) {clk_out,cnt} <= `FREQ_BIT'd0;
    else {clk_out,cnt} <= cnt_tmp;

endmodule