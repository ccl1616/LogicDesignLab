`timescale 1ns / 1ps

module note_generation(
    input clk, rst,
    input [21:0] note_division_left,
    input [21:0] note_division_right,
    output [15:0] audio_right,
    output [15:0] audio_left
    );

reg [21:0] clk_cnt_left, clk_cnt_left_next;
reg b_clk_left, b_clk_left_next;

reg [21:0] clk_cnt_right, clk_cnt_right_next;
reg b_clk_right, b_clk_right_next;

always@(posedge clk or posedge rst)
  if(rst)
    begin
      clk_cnt_left <= 22'b0;
      b_clk_left <= 1'b0;
    end
  else
    begin
      clk_cnt_left <= clk_cnt_left_next;
      b_clk_left <= b_clk_left_next;
    end
    
always@(*)
  if(clk_cnt_left == note_division_left)
    begin
      clk_cnt_left_next = 22'd0;
      b_clk_left_next = ~b_clk_left;
    end
  else
    begin
      clk_cnt_left_next = clk_cnt_left + 1'b1;
      b_clk_left_next = b_clk_left;
    end
    
always@(posedge clk or posedge rst)
  if(rst)
    begin
      clk_cnt_right <= 22'b0;
      b_clk_right <= 1'b0;
    end
  else
    begin
      clk_cnt_right <= clk_cnt_right_next;
      b_clk_right <= b_clk_right_next;
    end
    
always@(*)
  if(clk_cnt_right == note_division_right)
    begin
      clk_cnt_right_next = 22'd0;
      b_clk_right_next = ~b_clk_right;
    end
  else
    begin
      clk_cnt_right_next = clk_cnt_right + 1'b1;
      b_clk_right_next = b_clk_right;
    end

assign audio_right = (b_clk_right == 1'b0) ? 16'hB000 : 16'hB000 - 16'd2200;
assign audio_left = (b_clk_left == 1'b0) ? 16'hB000 : 16'hB000 - 16'd2200;

endmodule
