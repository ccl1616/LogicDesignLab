`timescale 1ns / 1ps

module cal_new(
    input clk,
    input rst,
    input [3:0]char,
    input [2:0]state,
    input is_number,
    input [1:0]opcode,
    input newkey,
    output reg [13:0]first, second,
    output wire is_neg,
    output reg [13:0]result
);
reg [13:0]first_tmp, second_tmp, result_tmp;

always@(*) begin
    if(state==3'd0 & newkey) begin
        if(is_number) begin
            if(first > 14'd99) first_tmp = first;
            else if(first == 14'd0) first_tmp[3:0] = char;
            else first_tmp = first*14'd10 + char;
        end
        else begin
            first_tmp = first;
            second_tmp = second;
        end
    end
    else if(state==3'd1 & newkey) begin
        if(is_number) begin
            if(second > 14'd99) second_tmp = second;
            else if(second == 14'd0) second_tmp[3:0] = char;
            else second_tmp = second*14'd10 + char;
        end
        else begin 
            first_tmp = first;
            second_tmp = second;
        end
    end
    else begin
        first_tmp = first;
        second_tmp = second;
    end
end

always@(posedge clk or posedge rst) begin
    if(rst) begin
        {first, second} <= {14'd0, 14'd0};
    end
    else begin
        {first, second} <= {first_tmp, second_tmp};
    end
end

// result
/*
opcode
    1 add
    2 sub
    3 mul
*/
assign is_neg = (first < second) ?1'b1:1'b0;
always@(*) begin
    if(opcode== 2'd1)
        result_tmp = first + second;
    else if(opcode== 2'd2) begin
        if(first < second) 
            result_tmp = second - first;
        else result_tmp = first - second;
    end
    else if(opcode== 2'd3)
        result_tmp = first * second;
    else 
        result_tmp = result;
end
always@(posedge clk or posedge rst) begin
    if(rst) begin
        result <= 14'd0;
    end
    else begin
        result <= result_tmp;
    end
end
endmodule
