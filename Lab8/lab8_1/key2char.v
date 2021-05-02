`include "global.v"
module key2char(
    clk,
    last_change,
    key_valid,
    char,
    flag
);
input clk;
input reg [8:0] last_change;
input key_valid;
output reg [3:0]char;

reg [8:0] last_change_prev;
reg flag;

always@(posedge key_valid) begin
    if(last_change_prev != last_change) begin
        last_change_prev <= last_change;
        flag <= ~flag;
    end
    else begin
        last_change_prev <= last_change_prev;
        flag <= flag;
    end
end

always@(*)begin
    case(last_change_prev)
        9'h70: char = `BCD_ZERO; //0
        9'h69: char = `BCD_ONE;
        9'h72: char = `BCD_TWO;
        9'h7A: char = `BCD_THREE;
        9'h6B: char = `BCD_FOUR;
        9'h73: char = `BCD_FIVE;
        9'h74: char = `BCD_SIX;
        9'h6C: char = `BCD_SEVEN;
        9'h75: char = `BCD_EIGHT;
        9'h7D: char = `BCD_NINE; //9
        9'h1C: char = `BCD_TEN; //A
        9'h1B: char = `BCD_ELEVEN; //S
        9'h3A: char = `BCD_TWELVE; //M
        9'h5A: char = `BCD_THIRTEEN; //enter
        default: char = `BCD_ZERO;
    endcase
end
endmodule