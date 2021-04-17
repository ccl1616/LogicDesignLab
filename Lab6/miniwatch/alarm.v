`include "global.v"
module alarm(
  output reg [9:0] led,
  output reg [`BCD_BIT_WIDTH-1:0] alarm_sec0,
  output reg [`BCD_BIT_WIDTH-1:0] alarm_sec1,
  output reg [`BCD_BIT_WIDTH-1:0] alarm_min0,
  output reg [`BCD_BIT_WIDTH-1:0] alarm_min1,
  input [`BCD_BIT_WIDTH-1:0] time_sec0,
  input [`BCD_BIT_WIDTH-1:0] time_sec1,
  input [`BCD_BIT_WIDTH-1:0] time_min0,
  input [`BCD_BIT_WIDTH-1:0] time_min1,
  input load_value_enable,
  input [`BCD_BIT_WIDTH-1:0] load_value_sec0,
  input [`BCD_BIT_WIDTH-1:0] load_value_sec1,
  input [`BCD_BIT_WIDTH-1:0] load_value_min0,
  input [`BCD_BIT_WIDTH-1:0] load_value_min1,
  input alarm_enable,
  input clk,
  input rst_n
);

reg [`BCD_BIT_WIDTH-1:0] alarm_sec0_next, alarm_sec1_next, alarm_min0_next, alarm_min1_next;

always @(posedge clk or negedge rst_n)
  if (~rst_n)
  begin
    alarm_sec0 <= 4'd0;
    alarm_sec1 <= 4'd0;
    alarm_min0 <= 4'd0;
    alarm_min1 <= 4'd0;
  end
  else
  begin
    alarm_sec0 <= alarm_sec0_next;
    alarm_sec1 <= alarm_sec1_next;
    alarm_min0 <= alarm_min0_next;
    alarm_min1 <= alarm_min1_next;
  end

always @*
  if (load_value_enable)
  begin
    alarm_sec0_next = load_value_sec0;
    alarm_sec1_next = load_value_sec1;
    alarm_min0_next = load_value_min0;
    alarm_min1_next = load_value_min1;
  end
  else 
  begin
    alarm_sec0_next = alarm_sec0;
    alarm_sec1_next = alarm_sec1;
    alarm_min0_next = alarm_min0;
    alarm_min1_next = alarm_min1;
  end

always @*
  if (alarm_enable && (alarm_min0 == time_min0) && (alarm_min1 == time_min1))
    led = 10'b11_1111_1111; 
  else
    led = 10'd0;

endmodule
