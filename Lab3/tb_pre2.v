module tb;

wire [`BIT_WIDTH-1 : 0] q;
reg clk;
reg rst_n;

shift U0(
    .q(q),
    .clk(clk),
    .rst_n(rst_n)
);
endmodule