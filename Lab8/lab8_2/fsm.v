`include "global.v"
`define STATE_0 2'd0
`define STATE_1 2'd1
`define STATE_2 2'd2
`define BCD_NULL 4'd13
module fsm(
    clk,
    rst,
    last_change,
    key_valid,
    // BCDs
    char, 
    dig0,
    dig1,
    dig2,
    dig3
);
input clk;
input rst;
input [8:0] last_change;
input key_valid;

input [3:0]char;
output reg [3:0]dig0;
output reg [3:0]dig1;
output reg [3:0]dig2;
output reg [3:0]dig3;

reg [8:0] last_change_prev;
always@(posedge clk) begin
    if(key_valid) begin
        if(last_change_prev != last_change)
            last_change_prev <= last_change;
        else 
            last_change_prev <= last_change_prev;
    end
end

wire newkey;
newkey = key_valid & (last_change_prev != last_change);

reg [1:0]state,next_state;
always@(*)begin
    case(state)
        `STATE_0: 
            begin
                if(newkey) begin
                    next_state = `STATE_1;
                    dig0 = char;
                end
                else begin
                    next_state = `STATE_0;
                    // all null
                    dig0 = `BCD_NULL;
                    dig1 = `BCD_NULL;
                    dig2 = `BCD_NULL;
                    dig3 = `BCD_NULL;
                end
            end
        `STATE_1:
            begin
                if(newkey) begin
                    next_state = `STATE_2;
                    dig1 = char;
                end
                else begin
                    next_state = `STATE_1;
                    // all null
                    dig1 = `BCD_NULL;
                    dig2 = `BCD_NULL;
                    dig3 = `BCD_NULL;
                end
            end
        `STATE_2:
            begin
                if(newkey)begin
                    if(char == `BCD_NULL) begin
                        next_state = `STATE_0;
                        dig0 = `BCD_NULL;
                        dig1 = `BCD_NULL;
                        dig2 = `BCD_NULL;
                        dig3 = `BCD_NULL;
                    end
                end
                else begin
                    next_state = `STATE_2;
                    dig2 = (dig0+dig1)>=4'd10 ?`BCD_ONE:`BCD_NULL;
                    dig3 = (dig0+dig1)>=4'd10 ?(dig0+dig1-4'd10):(dig0+dig1);
                end
            end
        default:
            begin
                next_state = `STATE_0;
                dig0 = `BCD_NULL;
                dig1 = `BCD_NULL;
                dig2 = `BCD_NULL;
                dig3 = `BCD_NULL;
            end
            
    endcase
end

// FSM state transition
always @(posedge clk or posedge rst)
  if (rst)
    state <= `STATE_0;
  else
    state <= next_state;

endmodule