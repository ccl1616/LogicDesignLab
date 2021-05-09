`include "global.v"
module upcounter_4d(
    nowlap, 
    en, // count enable input
    rst, // fsm pb rst signal
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
input nowlap;
input en; // fsm output
input rst; // fsm output
input clk;  
input rst_n;  // low active reset
wire [`BCD_BIT_WIDTH-1:0] value0;
wire [`BCD_BIT_WIDTH-1:0] value1;
wire [`BCD_BIT_WIDTH-1:0] value2;
wire [`BCD_BIT_WIDTH-1:0] value3;

wire carry_out0;
wire carry_out1;
wire carry_out2;
wire carry_out3;

assign increase_enable = en && (~((digit0==`BCD_NINE)&&(digit1==`BCD_FIVE)&&(digit2==`BCD_NINE)&&(digit3==`BCD_FIVE)));
assign new_rst_n = rst_n&(~rst); // low active reset

upcnt U_UC0(
  .q(value0), 
  .carry_in(increase_enable),
  .carry_out(carry_out0), 
  .init_val(4'd0),
  .limit(`BCD_NINE),
  .clk(clk),
  .rst_n(new_rst_n) // low active reset
);

upcnt U_UC1(
  .q(value1), 
  .carry_in(carry_out0),
  .carry_out(carry_out1), 
  .init_val(4'd0),
  .limit(`BCD_FIVE),
  .clk(clk),
  .rst_n(new_rst_n) // low active reset
);

upcnt U_UC2(
  .q(value2), 
  .carry_in(carry_out1),
  .carry_out(carry_out2), 
  .init_val(4'd0),
  .limit(`BCD_NINE),
  .clk(clk),
  .rst_n(new_rst_n) // low active reset
);

upcnt U_UC3(
  .q(value3), 
  .carry_in(carry_out2),
  .carry_out(carry_out3), 
  .init_val(4'd0),
  .limit(`BCD_FIVE),
  .clk(clk),
  .rst_n(new_rst_n) // low active reset
);

reg [`BCD_BIT_WIDTH-1:0] next0;
reg [`BCD_BIT_WIDTH-1:0] next1;
reg [`BCD_BIT_WIDTH-1:0] next2;
reg [`BCD_BIT_WIDTH-1:0] next3;

reg [`BCD_BIT_WIDTH-1:0] save0;
reg [`BCD_BIT_WIDTH-1:0] save1;
reg [`BCD_BIT_WIDTH-1:0] save2;
reg [`BCD_BIT_WIDTH-1:0] save3;

// mux
wire nowlap_syn;
assign nowlap_syn = nowlap;
/*
always @(posedge clk or negedge rst_n)
begin
    if(~rst_n) nowlap_syn <= 1'b0;
    else nowlap_syn <= nowlap;
end*/

always @* begin
  if(nowlap_syn == 1'b0) begin
    next0 = value0;
    next1 = value1;
    next2 = value2;
    next3 = value3;
  end
  else begin
    next0 = save0;
    next1 = save1;
    next2 = save2;
    next3 = save3;
  end
end

always @(posedge clk or negedge rst_n)
begin
  if(~rst_n) begin
    save0 <= 4'd0;
    save1 <= 4'd0;
    save2 <= 4'd0;
    save3 <= 4'd0;
  end
  else begin
    save0 <= next0;
    save1 <= next1;
    save2 <= next2;
    save3 <= next3;
  end
end

wire [`BCD_BIT_WIDTH-1:0] digit0; 
wire [`BCD_BIT_WIDTH-1:0] digit1; 
wire [`BCD_BIT_WIDTH-1:0] digit2;
wire [`BCD_BIT_WIDTH-1:0] digit3;
assign digit0 = next0;
assign digit1 = next1;
assign digit2 = next2;
assign digit3 = next3;
endmodule
