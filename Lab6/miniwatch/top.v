`include "global.v"
module t2(
  output [15:0] led,
  output  [`SSD_BIT_WIDTH-1:0] segs,  // 7-segment display
  output  [`SSD_NUM-1:0] ssd_ctl, // scan control for 7-segment display
  input mode,
  input switch,
  input  clk,  // clock from oscillator
  input  rst_n  // active low reset
);

wire clk_1, clk_2k; //divided clock
wire data_load_enable, reg_load_enable;
wire alarm_enable;
wire [1:0] set_min_sec;
reg [`BCD_BIT_WIDTH-1:0] sec0, sec1,min0, min1; // Binary counter output
wire [`BCD_BIT_WIDTH-1:0] ssd_in;
wire [`BCD_BIT_WIDTH-1:0] time_sec0, time_sec1,time_min0, time_min1; // Binary counter output
wire [`BCD_BIT_WIDTH-1:0] stopwatch_sec0, stopwatch_sec1, stopwatch_min0, stopwatch_min1; // Binary counter output
wire [`BCD_BIT_WIDTH-1:0] alarm_sec0, alarm_sec1,alarm_min0, alarm_min1; // Binary counter output
wire [`BCD_BIT_WIDTH-1:0] reg_q0, reg_q1, reg_q2, reg_q3; // Binary counter 
reg [`BCD_BIT_WIDTH-1:0] reg_load_q0, reg_load_q1, reg_load_q2, reg_load_q3; // Binary counter 
wire [4:0] state;
wire [4:0] state_led;
wire [9:0] alarm_led;
wire [9:0] stopwatch_led;

assign led = {state_led,{alarm_led|stopwatch_led},alarm_enable};

// clock generator
clock_generator Uclkgen(
  .clk_1(clk_1), // generated 1 Hz clock
  .clk_100(), // generated 100 Hz clock
  .clk_2k(clk_2k), // generated 100 Hz clock
  .clk(clk), // clock from crystal
  .rst_n(rst_n) // active low reset
);

// Time Display Counter
timedisplay Utd(
  .sec0(time_sec0),
  .sec1(time_sec1),
  .min0(time_min0),
  .min1(time_min1),
  .count_enable(`ENABLED),
  .load_value_enable(data_load_enable && (state[4:3] == `TIME)),
  .load_value_sec0(reg_q0),
  .load_value_sec1(reg_q1),
  .load_value_min0(reg_q2),
  .load_value_min1(reg_q3),
  .clk(clk_1),
  .rst_n(rst_n)
);

// Stopwatch
stopwatch Ustw(
  .led(stopwatch_led),
  .sec0(stopwatch_sec0), // counter value
  .sec1(stopwatch_sec1), // counter value
  .min0(stopwatch_min0), // counter value
  .min1(stopwatch_min1), // counter value
  .count_enable(stopwatch_count_enable), // counting enabled control signal
  .load_value_enable(data_load_enable && (state[4:3] == `STW)), // load setting value control
  .load_value_sec0(reg_q0), // value to be loaded
  .load_value_sec1(reg_q1), // value to be loaded
  .load_value_min0(reg_q2), // value to be loaded
  .load_value_min1(reg_q3), // value to be loaded
  .clk(clk_1), // clock
  .rst_n(rst_n) // low active reset
);

// Alarm
alarm(
  .led(alarm_led),
  .alarm_sec0(alarm_sec0),
  .alarm_sec1(alarm_sec1),
  .alarm_min0(alarm_min0),
  .alarm_min1(alarm_min1),
  .time_sec0(time_sec0),
  .time_sec1(time_sec1),
  .time_min0(time_min0),
  .time_min1(time_min1),
  .load_value_enable(data_load_enable && (state[4:3] == `ALM)),
  .load_value_sec0(reg_q0),
  .load_value_sec1(reg_q1),
  .load_value_min0(reg_q2),
  .load_value_min1(reg_q3),
  .alarm_enable(alarm_enable),
  .clk(clk_1),
  .rst_n(rst_n)
);

// FSM
fsm Ufsm(
  .state_led(state_led),
  .set_enable(set_enable),
  .stopwatch_count_enable(stopwatch_count_enable),
  .data_load_enable(data_load_enable),
  .reg_load_enable(reg_load_enable),
  .alarm_enable(alarm_enable),
  .set_min_sec(set_min_sec),
  .state(state),
  .mode(mode),
  .switch(switch),
  .clk(clk_1),
  .rst_n(rst_n)
);

// Selection which data to load to setting register
always @*
  case (state[4:3])
  `TIME:
    begin
      reg_load_q0 = time_sec0;
      reg_load_q1 = time_sec1;
      reg_load_q2 = time_min0;
      reg_load_q3 = time_min1;
    end
  `STW:
    begin
      reg_load_q0 = stopwatch_sec0;
      reg_load_q1 = stopwatch_sec1;
      reg_load_q2 = stopwatch_min0;
      reg_load_q3 = stopwatch_min1;
    end
  `ALM:
    begin
      reg_load_q0 = alarm_sec0;
      reg_load_q1 = alarm_sec1;
      reg_load_q2 = alarm_min0;
      reg_load_q3 = alarm_min1;
    end
  default:
    begin
      reg_load_q0 = 4'd0;
      reg_load_q1 = 4'd0;
      reg_load_q2 = 4'd0;
      reg_load_q3 = 4'd0;
    end
  endcase

// Setting Registers
unitset Usreg(
  .q0(reg_q0),
  .q1(reg_q1),
  .q2(reg_q2),
  .q3(reg_q3),
  .count_enable({set_enable & set_min_sec[1],set_enable & set_min_sec[0]}),
  .load_value_enable(reg_load_enable),
  .load_value_q0(reg_load_q0),
  .load_value_q1(reg_load_q1),
  .load_value_q2(reg_load_q2),
  .load_value_q3(reg_load_q3),
  .clk(clk_1),
  .rst_n(rst_n)
);

always @*
  case (state)
  `TIME_DISP:
    begin
      sec0 = time_sec0;
      sec1 = time_sec1;
      min0 = time_min0;
      min1 = time_min1;
    end
  `STW_DISP: 
    begin
      sec0 = stopwatch_sec0;
      sec1 = stopwatch_sec1;
      min0 = stopwatch_min0;
      min1 = stopwatch_min1;
    end
  `STW_START:
    begin
      sec0 = stopwatch_sec0;
      sec1 = stopwatch_sec1;
      min0 = stopwatch_min0;
      min1 = stopwatch_min1;
    end
  `STW_PAUSE:
    begin
      sec0 = stopwatch_sec0;
      sec1 = stopwatch_sec1;
      min0 = stopwatch_min0;
      min1 = stopwatch_min1;
    end
  `ALM_DISP:
    begin
      sec0 = alarm_sec0;
      sec1 = alarm_sec1;
      min0 = alarm_min0;
      min1 = alarm_min1;
    end
  `TIME_SETMIN:
    begin
      sec0 = reg_q0;
      sec1 = reg_q1;
      min0 = reg_q2;
      min1 = reg_q3;
    end
  `TIME_SETSEC:
    begin
      sec0 = reg_q0;
      sec1 = reg_q1;
      min0 = reg_q2;
      min1 = reg_q3;
    end
  `STW_SETMIN:
    begin
      sec0 = reg_q0;
      sec1 = reg_q1;
      min0 = reg_q2;
      min1 = reg_q3;
    end
  `STW_SETSEC:
    begin
      sec0 = reg_q0;
      sec1 = reg_q1;
      min0 = reg_q2;
      min1 = reg_q3;
    end
  `ALM_SETMIN:
    begin
      sec0 = reg_q0;
      sec1 = reg_q1;
      min0 = reg_q2;
      min1 = reg_q3;
    end
  `ALM_SETSEC:
    begin
      sec0 = reg_q0;
      sec1 = reg_q1;
      min0 = reg_q2;
      min1 = reg_q3;
    end
  default:
    begin
      sec0 = time_sec0;
      sec1 = time_sec1;
      min0 = time_min0;
      min1 = time_min1;
    end
  endcase

// Scan control
scan_ctl U_SC(
  .ssd_ctl(ssd_ctl), // ssd display control signal
  .ssd_in(ssd_in), // output to ssd display
  .in0(sec0), // 1st input
  .in1(sec1), // 2nd input
  .in2(min0), // 3rd input
  .in3(min1),  // 4th input
  .ssd_ctl_en(clk_2k), // divided clock for scan control
  .rst_n(rst_n)
);

// binary to 7-segment display decoder
display U_display(
  .segs(segs), // 7-segment display output
  .bin(ssd_in)  // BCD number input
);

endmodule
