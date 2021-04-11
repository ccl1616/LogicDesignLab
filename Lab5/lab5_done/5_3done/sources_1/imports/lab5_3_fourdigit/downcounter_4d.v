`include "global.v"
module downcounter_4d(
    chg_mode, // 0 for 25downcount, 1 for 1:30downcount
    digit0,  // 2nd digit of the down counter
    digit1,  // 1st digit of the down counter
    digit2,
    digit3,
    clk,  // global clock
    rst,
    rst_n,  // low active reset
    en // enable/disable for the stopwatch
);

output [`BCD_BIT_WIDTH-1:0] digit0; // 2nd digit of the down counter
output [`BCD_BIT_WIDTH-1:0] digit1; // 1st digit of the down counter
output [`BCD_BIT_WIDTH-1:0] digit2;
output [`BCD_BIT_WIDTH-1:0] digit3;
input chg_mode;
input clk;  // global clock
input rst_n;  // low active reset
input en; // enable/disable for the stopwatch
input rst;

wire br0,br1,br2,br3; // borrow indicator 
wire decrease_enable;
wire new_rst;
reg [3:0]init_val_0;
reg [3:0]init_val_1;
reg [3:0]init_val_2;

always@* begin
    if(chg_mode==1'b0) 
        {init_val_2,init_val_1,init_val_0} = {`BCD_ZERO,`BCD_TWO,`BCD_FIVE};
    else 
        {init_val_2,init_val_1,init_val_0} = {`BCD_ONE,`BCD_THREE,`BCD_ZERO};
end

assign decrease_enable = en && (~((digit0==`BCD_ZERO)&&(digit1==`BCD_ZERO)&&(digit2==`BCD_ZERO)));
assign new_rst_n = rst_n&(~rst); // low active reset

downcounter U_DC0(
  .value(digit0),  // counter value 
  .borrow(br0),  // borrow indicator for counter to next stage
  .clk(clk), // global clock signal
  .rst_n(new_rst_n),  // low active reset
  .decrease(decrease_enable),  // decrease input from previous stage of counter
  .init_value(init_val_0),  // initial value for the counter
  .limit(`BCD_NINE)  // limit for the counter
);

downcounter U_DC1(
  .value(digit1),  // counter value 
  .borrow(br1),  // borrow indicator for counter to next stage
  .clk(clk), // global clock signal
  .rst_n(new_rst_n),  // low active reset
  .decrease(br0),  // decrease input from previous stage of counter
  .init_value(init_val_1),  // initial value for the counter
  .limit(`BCD_FIVE)  // limit for the counter
);

downcounter U_DC2(
  .value(digit2),  // counter value 
  .borrow(br2),  // borrow indicator for counter to next stage
  .clk(clk), // global clock signal
  .rst_n(new_rst_n),  // low active reset
  .decrease(br1),  // decrease input from previous stage of counter
  .init_value(init_val_2),  // initial value for the counter
  .limit(`BCD_FIVE)  // limit for the counter
);

downcounter U_DC3(
  .value(digit3),  // counter value 
  .borrow(br3),  // borrow indicator for counter to next stage
  .clk(clk), // global clock signal
  .rst_n(new_rst_n),  // low active reset
  .decrease(br2),  // decrease input from previous stage of counter
  .init_value(`BCD_ZERO),  // initial value for the counter
  .limit(`BCD_FIVE)  // limit for the counter
);

endmodule
