// `include "global.v"
module tb;

reg mode;
reg rst_n;
reg clk;
wire long_press;
wire short_press;

`define CYC 10
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end
initial begin
    rst_n = 1'b0;
    mode = 1'b0;
    # (`CYC*2);
    // rst_n
    rst_n = 1'b1;
    mode = 1'b0;
    # (`CYC*2);
    mode = 1'b1;
    # (`CYC*5);
    mode = 1'b0;
    # (`CYC*2);
    mode = 1'b1;
    # (`CYC*5);
end

endmodule