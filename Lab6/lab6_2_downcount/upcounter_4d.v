`include "global.v"
module upcounter_4d(
  pbsec,
  pbmin,
  state,
  digit0,  // right most digit
  digit1, 
  digit2,
  digit3,
  clk,  // global clock
  rst_n,  // low active reset
);

output [`BCD_BIT_WIDTH-1:0] digit0; 
output [`BCD_BIT_WIDTH-1:0] digit1; 
output [`BCD_BIT_WIDTH-1:0] digit2;
output [`BCD_BIT_WIDTH-1:0] digit3;
input clk;  
input rst_n;  // low active reset
input [2:0]state;

wire [`BCD_BIT_WIDTH-1:0] carry_out0;
wire [`BCD_BIT_WIDTH-1:0] carry_out1;
wire [`BCD_BIT_WIDTH-1:0] carry_out2;
wire [`BCD_BIT_WIDTH-1:0] carry_out3;

// assign increase_enable = en && (~((digit0==`BCD_NINE)&&(digit1==`BCD_FIVE)&&(digit2==`BCD_NINE)&&(digit3==`BCD_FIVE)));

upcnt U_UC0(
  .q(value0), 
  .carry_in(state==3'b011 & pbsec),
  .carry_out(carry_out0), 
  .init_val(4'd0),
  .limit(`BCD_NINE),
  .clk(clk),
  .rst_n(rst_n) // low active reset
);

upcnt U_UC1(
  .q(value1), 
  .carry_in(carry_out0),
  .carry_out(carry_out1), 
  .init_val(4'd0),
  .limit(`BCD_FIVE),
  .clk(clk),
  .rst_n(rst_n) // low active reset
);

upcnt U_UC2(
  .q(value2), 
  .carry_in(state==3'b011 & pbmin),
  .carry_out(carry_out2), 
  .init_val(4'd0),
  .limit(`BCD_NINE),
  .clk(clk),
  .rst_n(rst_n) // low active reset
);

upcnt U_UC3(
  .q(value3), 
  .carry_in(carry_out2),
  .carry_out(carry_out3), 
  .init_val(4'd0),
  .limit(`BCD_FIVE),
  .clk(clk),
  .rst_n(rst_n) // low active reset
);

endmodule
