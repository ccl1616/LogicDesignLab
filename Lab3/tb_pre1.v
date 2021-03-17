`define CNT_BIT_WIDTH 4
module tb;
reg clk, rst_n;
wire [`CNT_BIT_WIDTH-1 : 0]q;
wire [`CNT_BIT_WIDTH-1 : 0]q_tmp;

bincnt U0(
    .q(q),
    .clk(clk),
    .rst_n(rst_n)
);

endmodule