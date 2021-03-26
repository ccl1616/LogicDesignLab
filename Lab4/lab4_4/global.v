`timescale 1ns / 1ps
// Frequency divider
`define FREQ_BIT 27 
`define DIV 50000000 
// Counter
`define CNT_BIT_WIDTH 4 //number of bits for the counter
`define LIMIT `CNT_BIT_WIDTH'd9

// 7-segment display
`define SSD_BIT_WIDTH 8 // 7-segment display control
`define SS_0 8'b0000_0011
`define SS_1 8'b1001_1111
`define SS_2 8'b0010_0101
`define SS_3 8'b0000_1101
`define SS_4 8'b1001_1001
`define SS_5 8'b0100_1001
`define SS_6 8'b0100_0001
`define SS_7 8'b0001_1111
`define SS_8 8'b0000_0001
`define SS_9 8'b0000_1001
`define SS_A 8'b0001_0001
`define SS_B 8'b1100_0001
`define SS_C 8'b0110_0011
`define SS_D 8'b1000_0101
`define SS_E 8'b0110_0001
`define SS_F 8'b0111_0001
`define SS_DEF 8'b0000_0000 // default, all LEDs being lighted

// scan
`define BCD_BIT_WIDTH 4 // BCD bit width
`define SSD_NUM 4 //number of 7-segment display
`define SSD_SCAN_CTL_BIT_WIDTH 2 // scan control bit with for 7-segment display