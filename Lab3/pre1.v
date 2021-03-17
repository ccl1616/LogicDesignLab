// 4 bit binary up counter

`define CNT_BIT_WIDTH 4
module bincnt(
    q,
    clk,
    rst_n
);

output [`CNT_BIT_WIDTH-1 : 0]q;
input clk;
input rst_n;

reg [`CNT_BIT_WIDTH-1 : 0]q;
reg [`CNT_BIT_WIDTH-1 : 0]q_tmp;

always@*
    q_tmp = q + 1'b1;

always@(posedge clk or negedge rst_n)
    if(~rst_n) q <= `CNT_BIT_WIDTH'd0;
    else q <= q_tmp;

endmodule