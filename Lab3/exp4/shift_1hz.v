// 1Hz 8bit shift

`define BIT_WIDTH 8
module shift_1hz(
    q,
    clk, //global clock
    rst_n
);
output [`BIT_WIDTH-1 : 0] q;
input clk;
input rst_n;

wire clk_div;
wire [`BIT_WIDTH-1 : 0]q;

freqdiv_50 U0(
    .ans(clk_div), // divided clock
    .clk(clk), // global clock, f crystal
    .rst_n(rst_n)
);

shift U1(
    .q(q),
    .clk(clk_div),
    .rst_n(rst_n)
);

endmodule