`timescale 1ns / 1ps
// Frequency divider
`define FREQ_BIT 27 
`define DIV 50000000 
// Counter
`define CNT_BIT_WIDTH 4 //number of bits for the counter

// 7-segment display
`define SSD_BIT_WIDTH 8 // 7-segment display control
`define SS_0 8'b0110_0001 //E
`define SS_1 8'b1001_0001 //H
`define SS_2 8'b1101_0101 //n
`define SS_3 8'b1110_0001 //t
`define SS_4 8'b1000_0011 //U
`define SS_5 8'b0110_0011 //C
`define SS_6 8'b0100_1001 //S
`define SS_DEF 8'b0000_0000 // default, all LEDs being lighted

// scan
`define BCD_BIT_WIDTH 4 // BCD bit width
`define SSD_NUM 4 //number of 7-segment display
`define SSD_SCAN_CTL_BIT_WIDTH 2 // scan control bit with for 7-segment display