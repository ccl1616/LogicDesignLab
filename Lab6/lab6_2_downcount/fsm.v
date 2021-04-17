`include "global.v"
module fsm(
    input pb_ps,
    input pb_start,
    input switch,
    input clk,
    input rst_n,
    input all_zero,
    output reg count_enable,
    output reg load_enable,
    output reg [2:0]state
);
reg [2:0] state_next;
// state transition
always @*
begin
    state_next = `STW;
    case(state)
    `STW:
        begin
            if(pb_start)
                state_next = `STW_COUNT;
            else if(swtich)
                state_next = `STW_SETTING;
            else state_next = `STW;
        end
    `STW_COUNT:
        begin
            if(pb_start)
                state_next = `STW;
            else if(all_zero)
                state_next = `STW;
            else if(pb_ps)
                state_next = `STW_PAUSE;
            else state_next = `STW_COUNT;
        end
    `STW_PAUSE:
        begin
            if(pb_ps)
                state_next = `STW_COUNT;
            else if(pb_start)
                state_next = `STW;
            else state_next = `STW_PAUSE;
        end
    `STW_SETTING:
        begin
            if(switch == 1'b0) 
                state_next = `STW;
            else state_next = `STW_SETTING;
        end
    endcase
end

// output 
always @*
begin
    count_enable = `FALSE;
    load_enable = `FALSE;
    case(state)
    `STW:
        begin
            count_enable = `FALSE;
            if(pb_start)
                load_enable = `TRUE;
            else load_enable = `FALSE;
        end
    `STW_COUNT:
        count_enable = `TRUE;
    `STW_PAUSE:
        count_enable = `FALSE;
    `STW_SETTING:
        begin
            if(switch == 1'b0)
                load_enable = `TRUE;
            else load_enable = `FALSE;
        end
    endcase
end

// state register
always @(posedge clk or negedge rst_n)
  if (~rst_n)
    state <= 3'b0;
  else
    state <= state_next; 
endmodule