`include "global"
module tb_fsm();
wire [15:0]led;
wire [`SSD_BIT_WIDTH-1:0] segs; // 7 segment display control
wire [`SSD_DIGIT_NUM-1:0] ssd_ctl; // scan control for 7-segment display
reg clk; // clock
reg rst_n; // low active reset
reg switch,pb_r,pb_l,pb_mode;

top U_TB(
    .switch(switch),
    .pb_r(pb_r),
    .pb_l(pb_l),
    .pb_mode(pb_mode),
    .clk(clk),
    .rst_n(rst_n),
    .led(led),
    .segs(segs), // 7 segment display control
    .ssd_ctl(ssd_ctl) // scan control for 7-segment display
);

`define CYC 10
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end
wire clk_100;
assign clk_100 = U_TB.clk_100;

initial begin
    rst_n = 1'b0;
    switch = 1'b0;
    pb_r = 1'b0;
    pb_l = 1'b0;
    pb_mode = 1'b0;
    repeat(1)@(posedge clk);
    rst_n = 1'b1;
    repeat(1)@(posedge clk);

end

endmodule