module tb;

reg clk;
reg rst_n; //active low reset
reg pb_in0;
wire segs;
wire ssd_ctl;
wire led0;
wire led1;

stopwatch U_tb(
    .segs(segs),
    .ssd_ctl(ssd_ctl),
    .led0(led0),
    .led1(led1),
    .clk(clk),
    .rst_n(rst_n),
    .pb_in0(pb_in0),
    .pb_in1(pb_in1)
);

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin
    rst_n = 1'b1;
    #5;
    rst_n = 1'b0;
    #5 
    pb_in1 = 1;
    #10*32;
    $stop;
end

endmodule