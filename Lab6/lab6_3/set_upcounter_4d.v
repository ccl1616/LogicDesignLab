`include "global.v"
module set_upcounter_4d(
  pbsec,
  pbmin,
  digit0,  // right most digit
  digit1, 
  digit2,
  digit3,
  clk,  // global clock
  rst_n  // low active reset
);

output [`BCD_BIT_WIDTH-1:0] digit0; 
output [`BCD_BIT_WIDTH-1:0] digit1; 
output [`BCD_BIT_WIDTH-1:0] digit2;
output [`BCD_BIT_WIDTH-1:0] digit3;
input clk;  
input rst_n;  // low active reset
input pbsec,pbmin;

wire [`BCD_BIT_WIDTH-1:0] carry_out0;
wire [`BCD_BIT_WIDTH-1:0] carry_out1;
wire [`BCD_BIT_WIDTH-1:0] carry_out2;
wire [`BCD_BIT_WIDTH-1:0] carry_out3;

// assign increase_enable = en && (~((digit0==`BCD_NINE)&&(digit1==`BCD_FIVE)&&(digit2==`BCD_NINE)&&(digit3==`BCD_FIVE)));

upcnt U_UC0(
  .q(digit0), 
  .carry_in(pbsec),
  .carry_out(carry_out0), 
  .init_val(`BCD_FIVE),
  .limit(`BCD_NINE),
  .clk(clk),
  .rst_n(rst_n) // low active reset
);

upcnt U_UC1(
  .q(digit1), 
  .carry_in(carry_out0),
  .carry_out(carry_out1), 
  .init_val(4'd0),
  .limit(`BCD_FIVE),
  .clk(clk),
  .rst_n(rst_n) // low active reset
);

upcnt U_UC2(
  .q(digit2), 
  .carry_in(pbmin),
  .carry_out(carry_out2), 
  .init_val(4'd0),
  .limit(`BCD_NINE),
  .clk(clk),
  .rst_n(rst_n) // low active reset
);

upcnt U_UC3(
  .q(digit3), 
  .carry_in(carry_out2),
  .carry_out(carry_out3), 
  .init_val(4'd0),
  .limit(`BCD_FIVE),
  .clk(clk),
  .rst_n(rst_n) // low active reset
);

endmodule
