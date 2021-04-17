module fsm(
  output reg [4:0] state_led,
  output reg set_enable,
  output reg stopwatch_count_enable,
  output reg data_load_enable,
  output reg reg_load_enable,
  output reg alarm_enable,
  output reg [1:0] set_min_sec,
  output reg [4:0] state,
  input mode,
  input switch,
  input clk,
  input rst_n
);

reg [4:0] state_next;
reg [1:0] press_count; 
wire [1:0] press_count_next;
reg mode_delay;
wire long_press, short_press;
reg alarm_enable_next;

//  Counter for press time
assign press_count_next = (mode) ? (press_count + 1'b1) : 2'd0;
always @(posedge clk or negedge rst_n)
  if (~rst_n)
    press_count <= 2'b0;
  else
    press_count <= press_count_next;

// Mode delay
always @(posedge clk or negedge rst_n)
  if (~rst_n)
    mode_delay <= 1'b0;
  else
    mode_delay <= mode;

// Determine short press or long press
assign short_press = (~mode) & mode_delay & (~(press_count[1]&press_count[0]));
assign long_press = (press_count == 2'b11);

// Alarm enable register
always @(posedge clk or negedge rst_n)
  if (~rst_n)
    alarm_enable = 1'b0;
  else
    alarm_enable = alarm_enable_next;

// state transition
always @*
begin
  set_enable = `DISABLED;
  stopwatch_count_enable = `DISABLED;
  data_load_enable = `DISABLED;
  set_min_sec = {2{`DISABLED}};
  reg_load_enable = `DISABLED;
  state_next = `TIME_DISP;
  alarm_enable_next = alarm_enable;
  state_led = state;
  case (state)
  `TIME_DISP:
    begin
      state_led = `TIME_DISP;
      if (long_press)
      begin
        state_next = `TIME_SETMIN;
        reg_load_enable = `ENABLED;
      end
      else if (short_press)
        state_next = `STW_DISP;
      else 
        state_next = `TIME_DISP;
    end
  `TIME_SETMIN:
    begin
      state_led = `TIME_SETMIN;
      set_enable = switch;
      set_min_sec = `SETMIN;
      if (short_press)
        state_next = `TIME_SETSEC;
      else if (long_press)
      begin
        state_next =  `TIME_DISP;
        data_load_enable = `ENABLED;
      end
      else
        state_next = `TIME_SETMIN;
    end
  `TIME_SETSEC:
    begin
      state_led = `TIME_SETSEC;
      set_enable = switch;
      set_min_sec = `SETSEC;
      if (short_press)
        state_next = `TIME_SETMIN;
      else if (long_press)
      begin
        state_next =  `TIME_DISP;
        data_load_enable = `ENABLED;
      end
      else
        state_next = `TIME_SETSEC;
    end
  `STW_DISP:
    begin
      state_led = `STW_DISP;
      if (long_press)
      begin
        state_next = `STW_SETMIN;
        reg_load_enable = `ENABLED;
      end
      else if (short_press)
        state_next = `ALM_DISP;
      else if (switch)
      begin
        state_next = `STW_START;
        stopwatch_count_enable = `ENABLED;
      end
      else
        state_next = `STW_DISP;
    end
  `STW_SETMIN:
    begin
      state_led = `STW_SETMIN;
      set_enable = switch;
      set_min_sec = `SETMIN;
      if (short_press)
        state_next = `STW_SETSEC;
      else if (long_press)
      begin
        state_next =  `STW_DISP;
        data_load_enable = `ENABLED;
      end
      else
        state_next = `STW_SETMIN;
    end
  `STW_SETSEC:
    begin
      state_led = `STW_SETSEC;
      set_enable = switch;
      set_min_sec = `SETSEC;
      if (short_press)
        state_next = `STW_SETMIN;
      else if (long_press)
      begin
        state_next =  `STW_DISP;
        data_load_enable = `ENABLED;
      end
      else
        state_next = `STW_SETSEC;
    end
  `STW_START:
    begin
      state_led = `STW_START;
      stopwatch_count_enable = `ENABLED;
      if (switch)
        state_next = `STW_PAUSE;
      else
        state_next = `STW_START;
    end
  `STW_PAUSE:
    begin
      state_led = `STW_PAUSE;
      stopwatch_count_enable = `DISABLED;
      if (switch)
        state_next = `STW_START;
      else if (long_press)
      begin
        state_next = `STW_DISP;
        data_load_enable = `ENABLED;
      end
      else
        state_next = `STW_PAUSE;
    end
  `ALM_DISP:
    begin
      state_led = `ALM_DISP;
      if (long_press)
      begin
        state_next = `ALM_SETMIN;
        reg_load_enable = `ENABLED;
      end
      else if (short_press)
        state_next = `TIME_DISP;
      else if (switch)
      begin
        state_next = `ALM_DISP;
        alarm_enable_next = ~ alarm_enable;
      end
      else
        state_next = `ALM_DISP;
    end
  `ALM_SETMIN:
    begin
      state_led = `ALM_SETMIN;
      set_enable = switch;
      set_min_sec = `SETMIN;
      if (short_press)
        state_next = `ALM_SETSEC;
      else if (long_press)
      begin
        state_next =  `ALM_DISP;
        data_load_enable = `ENABLED;
      end
      else
        state_next = `ALM_SETMIN;
    end
  `ALM_SETSEC:
    begin
      state_led = `ALM_SETSEC;
      set_enable = switch;
      set_min_sec = `SETSEC;
      if (short_press)
        state_next = `ALM_SETMIN;
      else if (long_press)
      begin
        state_next =  `ALM_DISP;
        data_load_enable = `ENABLED;
      end
      else
        state_next = `ALM_SETSEC;
    end
  endcase
end

// state register
always @(posedge clk or negedge rst_n)
  if (~rst_n)
    state <=5'b0;
  else
    state <= state_next;    

endmodule
