`include "global.v"
module fsm(
    clk,
    rst_n,
    switch,
    pb_mode,
    pb_l, pb_l_long,
    pb_r,
    all_zero,
    // output
    rst,
    load_en,
    down_en,
    up_en,
    nowlap,
    state
);
input clk;
input rst_n;
input switch;
input pb_mode;
input pb_l; input pb_l_long;
input pb_r;
input all_zero;
// output
output reg rst;
output reg load_en;
output reg down_en;
output reg up_en;
output reg nowlap;
output reg [2:0] state;
reg [2:0] state_next;

// state transition
always @*
begin
    state_next = `STW;
    case(state)
    `STW:
        begin
            if(pb_mode)
                state_next = `UPCNT_STOP;
            else if(pb_l)
                state_next = `STW_COUNT;
            else if(switch)
                state_next = `STW_SETTING;
            else state_next = `STW;
        end
    `STW_COUNT:
        begin
            if(pb_l)
                state_next = `STW;
            else if(all_zero)
                state_next = `STW;
            else if(pb_r)
                state_next = `STW_PAUSE;
            else state_next = `STW_COUNT;
        end
    `STW_PAUSE:
        begin
            if(pb_r)
                state_next = `STW_COUNT;
            else if(pb_l)
                state_next = `STW;
            else state_next = `STW_PAUSE;
        end
    `STW_SETTING:
        begin
            if(switch == 1'b0) 
                state_next = `STW;
            else state_next = `STW_SETTING;
        end
    `UPCNT_STOP:
        begin
            if(pb_mode)
                state_next = `STW;
            else if(pb_l)
                state_next = `UPCNT_START;
            else state_next = `UPCNT_STOP;
        end
    `UPCNT_START:
        begin
            if(pb_l)
                state_next = `UPCNT_STOP;
            else if(pb_r)
                state_next = `UPCNT_LAP;
            else state_next = `UPCNT_START;
        end
    `UPCNT_LAP:
        begin
            if(pb_r)
                state_next = `UPCNT_START;
            else state_next = `UPCNT_LAP;
        end

    endcase
end

// output 
always @*
begin
    load_en = `FALSE;
    down_en = `FALSE;
    up_en = `FALSE;
    nowlap = `FALSE;
    rst = `FALSE;
    case(state)
    `STW:
        if(pb_l) load_en = `TRUE;
    `STW_COUNT:
        down_en = `TRUE;
    `STW_PAUSE:
        down_en = `FALSE;
    `STW_SETTING:
        if(~switch) load_en = `TRUE;
    `UPCNT_STOP:
        begin
            if(pb_l_long) rst = `TRUE;
            else if(pb_l) up_en = `TRUE;
            else begin 
                rst = `FALSE;
                up_en = `TRUE;
            end
        end
    `UPCNT_START:
        begin
            if(pb_l) up_en = `FALSE;
            else up_en = `TRUE;
        end
    `UPCNT_LAP:
        begin
            nowlap = `TRUE;
            up_en = `TRUE;
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