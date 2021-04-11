`include "global.v"
module tb;
wire [`SSD_BIT_WIDTH-1:0] segs; // 7 segment display control
wire [`SSD_DIGIT_NUM-1:0] ssd_ctl; // scan control for 7-segment display
reg clk; // clock
reg rst_n; // low active reset
reg in0; // input control for FSM
reg in1;

stopwatch U_tb(
    .segs(segs), // 7 segment display control
    .ssd_ctl(ssd_ctl), // scan control for 7-segment display
    .clk(clk), // clock
    .rst_n(rst_n), // low active reset
    .in0(in0), 
    .in1(in1)
);
`define CYC 10
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin
    rst_n = 1'b0;
    {in0,in1} = {2'b00};
    # (`CYC*4);
    // rst
    rst_n = 1'b1;
    # (`CYC*4);
    {in0,in1} = {2'b01};
    # (`CYC*21);
    {in0,in1} = {2'b00};
    # (`CYC*5);
    {in0,in1} = {2'b01}; // back to s0
    # (`CYC*21);
    {in0,in1} = {2'b00};
    # (`CYC*21);
    $stop;
end


endmodule