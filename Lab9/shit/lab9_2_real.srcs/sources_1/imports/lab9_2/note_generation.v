`timescale 1ns / 1ps

module note_generation(
    input clk, rst,
    input [21:0] note_division,
    //input [15:0] amplitude_max, amplitude_min,
    output [15:0] audio_right,
    output [15:0] audio_left
    );

reg [21:0] clk_cnt, clk_cnt_next;
reg b_clk, b_clk_next;

always@(posedge clk or posedge rst)
  if(rst)
    begin
      clk_cnt <= 22'b0;
      b_clk <= 1'b0;
    end
  else
    begin
      clk_cnt <= clk_cnt_next;
      b_clk <= b_clk_next;
    end
    
always@(*)
  if(clk_cnt == note_division)
    begin
      clk_cnt_next = 22'd0;
      b_clk_next = ~b_clk;
    end
  else
    begin
      clk_cnt_next = clk_cnt + 1'b1;
      b_clk_next = b_clk;
    end

assign audio_right = (b_clk == 1'b0) ? 16'hB000 : 16'h5FFF;
assign audio_left = (b_clk == 1'b0) ? 16'hB000 : 16'h5FFF;

endmodule
