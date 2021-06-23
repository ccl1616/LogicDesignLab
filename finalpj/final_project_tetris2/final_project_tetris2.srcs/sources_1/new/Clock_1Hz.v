`timescale 1ns / 1ps

module clock_1Hz(
    input clk_origin,
    input rst,
    output reg clk_1Hz
);
reg [25:0] q_tmp;
    
always@(posedge clk_origin or posedge rst)
  begin
    if(rst)
      begin
        clk_1Hz <= 1'b0;
        q_tmp <= 26'b0;
      end
    else if(q_tmp == 26'd50000000)
      begin
        clk_1Hz <= ~clk_1Hz;
        q_tmp <= 26'b0;
      end
    else
      q_tmp <= q_tmp + 1'b1; 
  end

endmodule
