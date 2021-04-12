
`include "global.v"
module downcounter_2d(
  digit1,  // 2nd digit of the down counter
  digit0,  // 1st digit of the down counter
  clk,  // global clock
  rst,
  rst_n,  // low active reset
  en // enable/disable for the stopwatch
);

output [`BCD_BIT_WIDTH-1:0] digit1; // 2nd digit of the down counter
output [`BCD_BIT_WIDTH-1:0] digit0; // 1st digit of the down counter

input clk;  // global clock
input rst_n;  // low active reset
input en; // enable/disable for the stopwatch
input rst;

wire br0,br1; // borrow indicator 
wire decrease_enable;
wire new_rst;

assign decrease_enable = en && (~((digit0==`BCD_ZERO)&&(digit1==`BCD_ZERO)));
assign new_rst_n = rst_n&(~rst);
  
// 30 sec down counter
downcounter Udc0(
  .value(digit0),  // counter value 
  .borrow(br0),  // borrow indicator for counter to next stage
  .clk(clk), // global clock signal
  .rst_n(new_rst_n),  // low active reset
  .decrease(decrease_enable),  // decrease input from previous stage of counter
  .init_value(`BCD_FIVE),  // initial value for the counter
  .limit(`BCD_NINE)  // limit for the counter
);

downcounter Udc1(
  .value(digit1),  // counter value 
  .borrow(br1),  // borrow indicator for counter to next stage
  .clk(clk), // global clock signal
  .rst_n(new_rst_n),  // low active reset
  .decrease(br0),  // decrease input from previous stage of counter
  .init_value(`BCD_TWO),  // initial value for the counter
  .limit(`BCD_FIVE)  // limit for the counter
);

endmodule
