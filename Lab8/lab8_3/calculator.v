`timescale 1ns / 1ps
`define BCD_NULL 4'd13
`define BIGNUM_BIT_WIDTH 14

module calculator(
    input clk,rst,
    input [3:0] dig0,dig1,dig2,dig3,
    input is_add, is_subtract, is_multiple, is_enter, is_number,
    output wire is_neg,
    output reg [`BIGNUM_BIT_WIDT-1:0]result //14bit output
);

wire [`BIGNUM_BIT_WIDT-1:0]first,second;
assign first = (dig[3]!=`BCD_NULL)*dig[3] + dig[2];
assign second = (dig[1]!=`BCD_NULL)*dig[1] + dig[0];

reg [`BIGNUM_BIT_WIDT-1:0]result_tmp;
always@(*) begin
    if(is_add) begin
        result_tmp = first + second;
        is_neg = 1'b0;
    end
    else if(is_multiple) begin
        result_tmp = first * second;
        is_neg = 1'b0;
    end
    else if(is_subtract) begin
        if(first >= second) begin
            result_tmp = first - second;
            is_neg = 1'b0;
        end
        else begin
            result_tmp = second - first;
            is_neg = 1'b1;
        end
    end
    else begin
        is_neg = 1'b0;
        result_tmp = result;
    end
end

always@(posedge clk or posedge rst)
  if(rst)
    result <= (`BIGNUM_BIT_WIDT-1)'d0;
  else
    result <= result_tmp;

endmodule