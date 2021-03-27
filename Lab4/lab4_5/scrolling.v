// top module
`timescale 1ns / 1ps
`include "global.v"
module bcnt_7seg(
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
wire [`CNT_BIT_WIDTH-1:0] cnt_out2;
wire [`CNT_BIT_WIDTH-1:0] cnt_out3;
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

// 4bit binary up counter
shift U1(
    .out0(cnt_out0),
    .out1(cnt_out1),
    .out2(cnt_out2),
    .out3(cnt_out3),
    .clk(clk_d),
    .rst_n(rst_n)
);

// scan
scan_ctl U2(
    .ssd_ctl(ssd_ctl), // output ssd display control signal 
    .ssd_in(ssd_in), // output to ssd display
    .in0(cnt_out0), // 1st input
    .in1(cnt_out1), // 2nd input
    .in2(cnt_out2), // 3rd input
    .in3(cnt_out3),  // 4th input
    .ssd_ctl_en(ssd_ctl_en) // divided clock for scan control
);

//display
display U3(
    .segs(segs), // 14-segment segs output
    .bin(ssd_in)  // binary input
);

endmodule