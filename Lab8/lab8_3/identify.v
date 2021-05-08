`timescale 1ns / 1ps

module identify(
  input clk, rst,
  input [7:0]ascii,
  output reg [1:0] opcode,
  output reg is_enter, is_number,
  output reg [3:0] char
);

reg [1:0] opcode_tmp;
reg is_enter_tmp, is_number_tmp;
reg [3:0] char_tmp;

always@(*) begin
  if(ascii == 8'hE0) begin
        // enter
        {opcode_tmp, is_enter_tmp, is_number_tmp, char_tmp } = { 2'b00, 1'b1, 1'b10 ascii[3:0] };
  end
  else if(ascii >= 8'h30) 
        {opcode_tmp, is_enter_tmp, is_number_tmp, char_tmp } = { 2'b00, 1'b0, 1'b1, ascii[3:0] };
  else if(ascii[7:4] == 4'h2) begin
      if(ascii[3:0] == 4'hA) begin
        // mul
        {opcode_tmp, is_enter_tmp, is_number_tmp, char_tmp } = { 2'b11, 1'b0, 1'b10 ascii[3:0] };
      end
      else if(ascii[3:0] == 4'hb) begin
        // add
        {opcode_tmp, is_enter_tmp, is_number_tmp, char_tmp } = { 2'b01, 1'b0, 1'b10 ascii[3:0] };
      end
      else begin
        // sub
        {opcode_tmp, is_enter_tmp, is_number_tmp, char_tmp } = { 2'b10, 1'b0, 1'b10 ascii[3:0] };
      end
  end
  else 
        {opcode_tmp, is_enter_tmp, is_number_tmp, char_tmp } = {opcode, is_enter, is_number, char};
end

always@(posedge clk or posedge rst)
  if(rst)
    {opcode, is_enter, is_number, char} = 8'd0;
  else
    {opcode, is_enter, is_number, char} = {opcode_tmp, is_enter_tmp, is_number_tmp, char_tmp };

endmodule
