// top module
`timescale 1ns / 1ps
`include "global.v"
module two_bcd_up(
  segs,  // 7-segment display
  ssd_ctl, // scan control for 7-segment display
  clk,  // clock from oscillator
  rst_n  // active low reset
);

output [`SSD_BIT_WIDTH-1:0] segs; // 7-segment display out
output [`SSD_NUM-1:0] ssd_ctl;
input  clk;  // clock from oscillator
input  rst_n;  // active low reset

wire clk_d; //divided clock
wire [`CNT_BIT_WIDTH-1:0] cnt_out0; // Binary counter output
wire [`CNT_BIT_WIDTH-1:0] cnt_out1;
wire [`SSD_SCAN_CTL_BIT_WIDTH-1:0] ssd_ctl_en;
wire [`SSD_NUM-1:0] ssd_ctl;
wire [`CNT_BIT_WIDTH-1:0] ssd_in;

// frequency divider
freqdiv U0(
    .clk_out(clk_d), // 1Hz output
    .clk_ctl(ssd_ctl_en), // 2bit output
    .clk(clk), // input
    .rst_n(rst_n) // input active low reset
);

// 2 bcd digit
two_cnt U1(
    .out0(cnt_out0), //output
    .out1(cnt_out1),
    .clk(clk_d),
    .rst_n(rst_n)
);

// scan
scan_ctl U2(
    .ssd_ctl(ssd_ctl), // output ssd display control signal 
    .ssd_in(ssd_in), // output to ssd display
    .in0(cnt_out0), // 1st input
    .in1(cnt_out1), // 2nd input
    .in2(4'b0000), // 3rd input
    .in3(4'b0000),  // 4th input
    .ssd_ctl_en(ssd_ctl_en) // divided clock for scan control
);

//display
display U3(
    .segs(segs), // 14-segment segs output
    .bin(ssd_in)  // binary input
);

endmodule