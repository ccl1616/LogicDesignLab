`timescale 1ns / 1ps
`include "global.v"
module clkgen_2hz(
  clk, // clock from crystal
  rst_n, // active low reset
  clk_2, // generated 2 Hz clock
  clk_4 // generated 4 Hz clock
);

// Declare I/Os
input clk; // clock from crystal
input rst_n; // active low reset
output clk_2; // generated 1 Hz clock
output clk_4; 
reg clk_2; // generated 1 Hz clock
reg clk_4; 

// Declare internal nodes
reg [`DIV_BY_50M_BIT_WIDTH-1:0] count_25M, count_25M_next;
reg [`DIV_BY_50M_BIT_WIDTH-1:0] count_12500K, count_12500K_next;
reg clk_2_next;
reg clk_4_next;

// *******************
// Clock divider for 1 Hz
// *******************
// Clock Divider: Counter operation
always @*
  if (count_25M == `DIV_BY_25M-1)
  begin
    count_25M_next = `DIV_BY_50M_BIT_WIDTH'd0;
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
    count_25M <=`DIV_BY_50M_BIT_WIDTH'b0;
    clk_2 <=1'b0;
  end
  else
  begin
    count_25M <= count_25M_next;
    clk_2 <= clk_2_next;
  end

// *********************
// Clock divider for 4 Hz
// *********************
// Clock Divider: Counter operation 
always @*
  if (count_12500K == `DIV_BY_12500K-1)
  begin
    count_12500K_next = `DIV_BY_50M_BIT_WIDTH'd0;
    clk_4_next = ~clk_4;
  end
  else
  begin
    count_12500K_next = count_12500K + 1'b1;
    clk_4_next = clk_4;
  end


// Counter flip-flops
always @(posedge clk or negedge rst_n)
  if (~rst_n)
  begin
    count_12500K <=`DIV_BY_50M_BIT_WIDTH'b0;
    clk_4 <=1'b0;
  end
  else
  begin
    count_12500K <= count_12500K_next;
    clk_4 <= clk_4_next;
  end

endmodule
