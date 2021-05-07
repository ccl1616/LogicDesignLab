`define BCD_NULL 4'd13

module assign_number(
    input clk ,rst,
    input is_number,
    input [2:0] sel,
    input [3:0] char, // char!!
    output reg [3:0] dig0,dig1,dig2,dig3
);
reg [3:0] dig0_tmp,dig1_tmp,dig2_tmp,dig3_tmp;

always@(*) begin
    if(sel==3'd1 & is_number) begin
        dig0_tmp = char;
        dig1_tmp = dig1;
        dig2_tmp = dig2;
        dig3_tmp = dig3;
    end
    else if(sel==3'd2 & is_number) begin
        dig0_tmp = char;
        dig1_tmp = dig0;
        dig2_tmp = dig2;
        dig3_tmp = dig3;
    end
    else if(sel==3'd3) begin
        dig0_tmp = `BCD_NULL;
        dig1_tmp = `BCD_NULL;
        dig2_tmp = dig0;
        dig3_tmp = dig1;
    end
    else if(sel==3'd4) begin
        dig0_tmp = char;
        dig1_tmp = `BCD_NULL;
        dig2_tmp = dig2;
        dig3_tmp = dig3;
    end
    else if(sel==3'd5) begin
        dig0_tmp = char;
        dig1_tmp = dig0;
        dig2_tmp = dig2;
        dig3_tmp = dig3;
    end
    else begin
        dig0_tmp = dig0;
        dig1_tmp = dig1;
        dig2_tmp = dig2;
        dig3_tmp = dig3;
    end
end

always@(posedge clk or posedge rst)
  if(rst) begin
    dig0 <= `BCD_NULL;
    dig1 <= `BCD_NULL;
    dig2 <= `BCD_NULL;
    dig3 <= `BCD_NULL;
  end
  else begin
    dig0 <= dig0_tmp;
    dig1 <= dig1_tmp;
    dig2 <= dig2_tmp;
    dig3 <= dig3_tmp;
  end

endmodule