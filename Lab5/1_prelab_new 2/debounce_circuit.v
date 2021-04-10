`timescale 1ns / 1ps
`include "global.v"
module debounce_circuit(
  clk, // clock control
  rst_n, // reset
  pb_in, //push button input
  pb_debounced // debounced push button output
);

// declare the I/Os
input clk; // clock control
input rst_n; // reset
input pb_in; //push button input
output pb_debounced; // debounced push button output
reg pb_debounced; // debounced push button output

// declare the internal nodes
reg [`DEBOUNCE_WINDOW_SIZE-1:0] debounce_window; // shift register flip flop
reg pb_debounced_next; // debounce result

// Shift register
always @(posedge clk or negedge rst_n)
  if (~rst_n)
    debounce_window <= `DEBOUNCE_WINDOW_SIZE'd0;
  else
    debounce_window <= {debounce_window[`DEBOUNCE_WINDOW_SIZE-2:0],pb_in}; 

// debounce circuit
always @*
  if (debounce_window == `DEBOUNCE_WINDOW_SIZE'b1111) 
    pb_debounced_next = 1'b1;
  else
    pb_debounced_next = 1'b0;

always @(posedge clk or negedge rst_n)
  if (~rst_n)
    pb_debounced <= 1'b0;
  else
    pb_debounced <= pb_debounced_next;
	 
endmodule
