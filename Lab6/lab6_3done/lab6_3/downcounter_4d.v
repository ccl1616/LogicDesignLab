`include "global.v"
module downcounter_4d(
  input [`BCD_BIT_WIDTH-1:0] loadval0,
  input [`BCD_BIT_WIDTH-1:0] loadval1,
  input [`BCD_BIT_WIDTH-1:0] loadval2,
  input [`BCD_BIT_WIDTH-1:0] loadval3,
  output [`BCD_BIT_WIDTH-1:0] digit0,  // 2nd digit of the down counter
  output [`BCD_BIT_WIDTH-1:0] digit1,  // 1st digit of the down counter
  output [`BCD_BIT_WIDTH-1:0] digit2,
  output [`BCD_BIT_WIDTH-1:0] digit3,
  input clk,  // global clock
  input rst_n,  // low active reset
  input load_enable,
  input en // enable/disable for the stopwatch
);
wire load_enable_1;
assign load_enable_1 =load_enable;
wire en_1;
assign en_1 = en;
/*
always@(posedge clk or negedge rst_n)
  if(~rst_n) begin
    load_enable_1 <= 1'b0;
    en_1 <= 1'b0;
  end
  else begin
    load_enable_1 <= load_enable;
    en_1 <= en;
  end*/

wire br0,br1,br2,br3; // borrow indicator 
wire decrease_enable;
assign decrease_enable = en_1 && (~((digit0==`BCD_ZERO)&&(digit1==`BCD_ZERO)&&(digit2==`BCD_ZERO)&&(digit3==`BCD_ZERO)));

downcounter U_DC0(
  .value(digit0),  // counter value 
  .borrow(br0),  // borrow indicator for counter to next stage
  .clk(clk), // global clock signal
  .rst_n(rst_n),  // low active reset
  .decrease(decrease_enable),  // decrease input from previous stage of counter
  .init_value(loadval0),  // initial value for the counter
  .limit(`BCD_NINE),  // limit for the counter
  .load(load_enable_1)
);

downcounter U_DC1(
  .value(digit1),  // counter value 
  .borrow(br1),  // borrow indicator for counter to next stage
  .clk(clk), // global clock signal
  .rst_n(rst_n),  // low active reset
  .decrease(br0),  // decrease input from previous stage of counter
  .init_value(loadval1),  // initial value for the counter
  .limit(`BCD_FIVE),  // limit for the counter
  .load(load_enable_1)
);

downcounter U_DC2(
  .value(digit2),  // counter value 
  .borrow(br2),  // borrow indicator for counter to next stage
  .clk(clk), // global clock signal
  .rst_n(rst_n),  // low active reset
  .decrease(br1),  // decrease input from previous stage of counter
  .init_value(loadval2),  // initial value for the counter
  .limit(`BCD_NINE),  // limit for the counter
  .load(load_enable_1)
);

downcounter U_DC3(
  .value(digit3),  // counter value 
  .borrow(br3),  // borrow indicator for counter to next stage
  .clk(clk), // global clock signal
  .rst_n(rst_n),  // low active reset
  .decrease(br2),  // decrease input from previous stage of counter
  .init_value(loadval3),  // initial value for the counter
  .limit(`BCD_FIVE),  // limit for the counter
  .load(load_enable_1)
);

endmodule
