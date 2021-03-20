// 1Hz with 4bit binary up counter

`define CNT_BIT_WIDTH 4
module bupcnt_1hz(
    q,
    clk, //global clock
    rst_n
);

output [`CNT_BIT_WIDTH-1 : 0]q;
input clk;
input rst_n;

wire clk_div;
wire [`CNT_BIT_WIDTH-1 : 0]q; // ?

freqdiv_50 U0(
    .ans(clk_div), // divided clock
    .clk(clk), // global clock, f crystal
    .rst_n(rst_n)
);

bincnt U1(
    .q(q),
    .clk(clk_div),
    rst_n(rst_n)
);

endmodule