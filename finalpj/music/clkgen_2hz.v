`timescale 1ns / 1ps
`include "global.v"
module clock_generator(
  clk, // clock from crystal
  rst_n, // active low reset
  clk_2, // generated 2 Hz clock
  clk_100 // generated 100 Hz clock
);

// Declare I/Os
input clk; // clock from crystal
input rst_n; // active low reset
output clk_2; // generated 1 Hz clock
output clk_100; // generated 100 Hz clock
reg clk_2; // generated 1 Hz clock
reg clk_100; // generated 100 Hz clock

// Declare internal nodes
reg [`DIV_BY_25M_BIT_WIDTH-1:0] count_25M, count_25M_next;
reg [`DIV_BY_500K_BIT_WIDTH-1:0] count_500K, count_500K_next;
reg clk_2_next;
reg clk_100_next;

// *******************
// Clock divider for 1 Hz
// *******************
// Clock Divider: Counter operation
always @*
  if (count_25M == `DIV_BY_25M-1)
  begin
    count_25M_next = `DIV_BY_25M_BIT_WIDTH'd0;
    clk_2_next = ~clk_2;
  end
  else
  begin
    count_25M_next = count_25M + 1'b1;
    clk_2_next = clk_2;
  end

// Counter flip-flops
always @(posedge clk or negedge rst_n)
  if (~rst_n)
  begin
    count_25M <=`DIV_BY_25M_BIT_WIDTH'b0;
    clk_2 <=1'b0;
  end
  else
  begin
    count_25M <= count_25M_next;
    clk_2 <= clk_2_next;
  end

// *********************
// Clock divider for 100 Hz
// *********************
// Clock Divider: Counter operation 
always @*
  if (count_500K == `DIV_BY_500K-1)
  begin
    count_500K_next = `DIV_BY_500K_BIT_WIDTH'd0;
    clk_100_next = ~clk_100;
  end
  else
  begin
    count_500K_next = count_500K + 1'b1;
    clk_100_next = clk_100;
  end


// Counter flip-flops
always @(posedge clk or negedge rst_n)
  if (~rst_n)
  begin
    count_500K <=`DIV_BY_500K_BIT_WIDTH'b0;
    clk_100 <=1'b0;
  end
  else
  begin
    count_500K <= count_500K_next;
    clk_100 <= clk_100_next;
  end

endmodule
