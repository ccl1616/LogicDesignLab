// build a counter for 50M
// and generate 1Hz signal by 100M/(2*50M) = 1Hz

// divide 50M
/*
`define FREQ_BIT 26 
`define DIV 50000000 
*/

`define FREQ_BIT 13 
`define DIV 5000

module freqdiv_50(
    q,
    clk,
    rst_n
);

output [`FREQ_BIT-1 : 0] q;
input clk;
input rst_n;

reg [`FREQ_BIT-1 : 0] q;
reg [`FREQ_BIT-1 : 0] cnt_tmp; //input to DFF

// combinational
always@*
    cnt_tmp = q + 1'b1;

// sequential
always @(posedge clk or negedge rst_n)
    if(~rst_n) q <= `FREQ_BIT'd(`DIV-10); //to this
    else q <= (q == `FREQ_BIT'd(`DIV-1) )? `FREQ_BIT'd0:cnt_tmp;
endmodule