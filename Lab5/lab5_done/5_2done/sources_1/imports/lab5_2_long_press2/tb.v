`include "global.v"
module tb;
wire [`SSD_BIT_WIDTH-1:0] segs; // 7 segment display control
wire [`SSD_DIGIT_NUM-1:0] ssd_ctl; // scan control for 7-segment display
wire [15:0]led;
reg clk; // clock
reg rst_n; // low active reset
reg in0; 

stopwatch_v2 U_tb(
    .led(led),
    .segs(segs), // 7 segment display control
    .ssd_ctl(ssd_ctl), // scan control for 7-segment display
    .clk(clk), // clock
    .rst_n(rst_n), // low active reset
    .pb_in(in0)
);
`define CYC 10
wire clk_100;
assign clk_100 = U_tb.clk_100;
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin
    rst_n = 1'b0;
    in0 = 2'd0;
    # (`CYC*2);
    // rst
    rst_n = 1'b1;
    in0 = 1'd1;
    repeat(5) @(posedge clk_100);
    in0 = 1'd0;
end


endmodule