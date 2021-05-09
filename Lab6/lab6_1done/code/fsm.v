`include "global.v"
module fsm(
    state_o,
    clk, // global clock signal
    rst_n, // low active reset
    in0,
    in1,
    // output
    count_enable,  // if counter is enabled 
    rst //input control
);
// inputs
input clk; // global clock signal
input rst_n; // low active reset
input in0; // btn for rst
input in1; // btn for pause/start
// outputs
output rst;
output count_enable;  // if counter is enabled 
output state_o;

reg count_enable;  // if counter is enabled 
reg state; // state of FSM
reg next_state; // next state of FSM
reg rst;
wire state_o = state;

// ***************************
// FSM
// ***************************
// FSM state decision
always @*
  case (state)
    `STAT_PAUSE:
      if ( {in0,in1}==2'b10 ) // rst at pause
      begin
        next_state = `STAT_PAUSE;
        {rst,count_enable} = { `ENABLED, `DISABLED };
        //rst = `ENABLED;
        //count_enable = `DISABLED;
      end
      else if( {{in0,in1}==2'b01} ) // start at pause
      begin
        next_state = `STAT_COUNT;
        {rst,count_enable} = { `DISABLED,`ENABLED };
        //rst = `DISABLED;
        //count_enable = `DISABLED;
      end
      else
      begin
        next_state = `STAT_PAUSE;
        {rst,count_enable} = { `DISABLED,`DISABLED };
      end
    `STAT_COUNT:
      if ( {in0,in1}==2'b10 ) // rst at counting
      begin
        next_state = `STAT_COUNT;
        {rst,count_enable} = { `DISABLED,`ENABLED };
      end
      else if ( {in0,in1}==2'b01 ) //pause at count
      begin
        next_state = `STAT_PAUSE;
        {rst,count_enable} = { `DISABLED,`DISABLED };
      end
      else
      begin
        next_state = `STAT_COUNT;
        {rst,count_enable} = { `DISABLED,`ENABLED };
      end

    default:
      begin
        next_state = `STAT_PAUSE;	 
        {rst,count_enable} = { `DISABLED,`DISABLED };
    end
  endcase

// FSM state transition
always @(posedge clk or negedge rst_n)
  if (~rst_n)
    state <= `STAT_PAUSE;
  else
    state <= next_state;

endmodule