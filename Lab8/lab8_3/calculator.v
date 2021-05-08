`timescale 1ns / 1ps
`define BCD_NULL 4'd13
`define BIGNUM_BIT_WIDTH 14

module calculator(
    input clk,rst,
    input [3:0] dig0,dig1,dig2,dig3,
    input is_add, is_subtract, is_multiple,
    output reg is_neg,
    output reg [`BIGNUM_BIT_WIDT-1:0]result //14bit output
);

wire [`BIGNUM_BIT_WIDT-1:0]first,second;
assign first = dig3 * 14'd10 + dig2;
assign second = dig1 * 14'd10 + dig0;

reg [`BIGNUM_BIT_WIDT-1:0]result_tmp;
reg is_neg_tmp;
always@(*) begin
    if(is_add) begin
        result_tmp = first + second;
        is_neg_tmp = 1'b0;
    end
    else if(is_multiple) begin
        result_tmp = first * second;
        is_neg_tmp = 1'b0;
    end
    else if(is_subtract) begin
        if(first >= second) begin
            result_tmp = first - second;
            is_neg_tmp = 1'b0;
        end
        else begin
            result_tmp = second - first;
            is_neg_tmp = 1'b1;
        end
    end
    else begin
        result_tmp = result;
        is_neg_tmp = 1'b0;
    end
end

always@(posedge clk or posedge rst)
  if(rst) begin
    result <= (`BIGNUM_BIT_WIDT-1)'d0;
    is_neg <= 1'b0;
  end
  else begin
    result <= result_tmp;
    is_neg <= is_neg_tmp;
  end
endmodule