`include "global.v"
module top(
    pb_in,
    rst_n,
    clk,
    led //use led to output press state
);
wire [1:0]led;

press U_p(
    .mode(pb_in),
    .short_press(led[0]),
    .long_press(led[1]),
    .rst_n(rst_n),
    .clk(clk)
);
endmodule