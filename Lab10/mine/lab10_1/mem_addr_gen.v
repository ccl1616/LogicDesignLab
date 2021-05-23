module mem_addr_gen(
  input clk,
  input rst,
  input en,
  input [9:0] h_cnt,
  input [9:0] v_cnt,
  output [16:0] pixel_addr
);
    
reg [7:0] position;
  
assign pixel_addr = ((h_cnt>>1)+320*(v_cnt>>1)+ position*320 )% 76800;  //640*480 --> 320*240 

always @ (posedge clk or posedge rst) begin
  if(rst)
    position <= 0;
  else if(position < 239)
    position <= position + en;
  else
    position <= 0;
end
/*
always @ (posedge clk or posedge rst) begin
  if(rst)
    position <= 8'd239;
  else if(position > 8'd0)
    position <= position - en;
  else
    position <= 8'd239;
end 
*/

endmodule
