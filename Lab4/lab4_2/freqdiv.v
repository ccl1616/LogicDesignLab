// generate a 1Hz output
// build a counter for 50M and generate 1Hz signal by 100M/(2*50M) = 1Hz
`include "global.v"
module freqdiv(
    clk_div, // 1Hz output
    clk_ctl, // 2bit output
    clk, // input
    rst_n // input active low reset
);

input clk;
input rst_n;
output clk_div;
output clk_ctl;
wire cmp;
wire t_tmp;
wire [1:0]clk_ctl;

reg [`FREQ_BIT-1 : 0] q;
reg [`FREQ_BIT-1 : 0] cnt_tmp; //input to DFF
reg t_tmp;
reg clk_div;

// div 50M
// combinational
always@*
    if(q == `FREQ_BIT'd`DIV-1) cnt_tmp = `FREQ_BIT'd0;
    else cnt_tmp = q + 1'b1;
assign clk_ctl = q[1:0];

// sequential
always @(posedge clk or negedge rst_n)
    if(~rst_n) 
        q <= `FREQ_BIT'd0; 
    else 
        q <= cnt_tmp;

assign cmp = (q == `FREQ_BIT'd`DIV-1)? 1:0;

// tff
assign t_tmp = clk_div^cmp;

always @(posedge clk or negedge rst_n)
    if(~rst_n) clk_div <= 0;
    else clk_div <= t_tmp;
endmodule