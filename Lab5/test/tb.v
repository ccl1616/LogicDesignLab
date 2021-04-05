`include "global.v"
module tb;
wire [`SSD_BIT_WIDTH-1:0] segs; // 7 segment display control
wire [`SSD_DIGIT_NUM-1:0] ssd_ctl; // scan control for 7-segment display
reg clk; // clock
reg rst_n; // low active reset
reg in; // input control for FSM

stopwatch U_tb(
    .segs(segs), // 7 segment display control
    .ssd_ctl(ssd_ctl), // scan control for 7-segment display
    .clk(clk), // clock
    .rst_n(rst_n), // low active reset
    .in(in) // input control for FSM
);
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin
    rst_n = 1'b1;
    #5;
    rst_n = 1'b0;
    in = 1'b1;
    #5;
    in = 1'b0;

    #(10*32);
    $stop;
end


endmodule