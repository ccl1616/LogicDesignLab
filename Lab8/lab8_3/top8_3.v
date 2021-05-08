`timescale 1ns / 1ps
`include "global.v"
module top8_3(
    inout wire PS2_DATA,
    inout wire PS2_CLK,
    input wire rst,
    input wire clk,
    output wire [3:0] ssd_ctl,
    output wire [7:0] segs,
    output wire [15:0] led
);
wire [2:0]state;
wire [3:0] char;
wire flag;
assign led[3:0] = char;
assign led[15:13] = state;

//**************************************************************
// Keyboard block
wire [511:0] key_down;
wire [8:0] last_change;
wire key_valid;
wire key_down_op; // onepulse
KeyboardDecoder U_KD(
	.key_down(key_down),
	.last_change(last_change),
	.key_valid(key_valid),
	.PS2_DATA(PS2_DATA),
	.PS2_CLK(PS2_CLK),
	.rst(rst),
	.clk(clk)
);

key2char U_K2C(
    .clk(clk),
    .last_change(last_change),
    .key_valid(key_valid),
    .char(char),
    .flag(flag)
);

one_pulse U_OP0(
  .clk(clk),  // clock input
  .rst_n(~rst), //active low reset
  .in_trig(key_down[last_change]), // input trigger
  .out_pulse(key_down_op) //  output , use as SET pb into chg_mode of counter
);

//**************************************************************
// pre-calculate
wire is_add, is_subtract, is_multiple, is_enter, is_number;
wire [2:0]sel;
wire [3:0] dig0,dig1,dig2,dig3;

identify U_IDENT(
    .clk(clk), 
    .rst(rst),
    .last_change(last_change),
    .is_add(is_add), 
    .is_subtract(is_subtract), 
    .is_multiple(is_multiple), 
    .is_enter(is_enter), 
    .is_number(is_number)
);
number U_NUM(
    .clk(clk), 
    .rst(rst),
    .is_number(is_number),
    .sel(sel), //input
    .char(char), 
    .dig0(dig0),
    .dig1(dig1),
    .dig2(dig2),
    .dig3(dig3)
);

//**************************************************************
// fsm block , real calculation
wire is_neg;
wire [13:0]result;
wire [3:0] re_dig0, re_dig1, re_dig2, re_dig3;
assign led[4] = is_neg;
fsm U_FSM(
    .newkey(key_down_op),
    .clk(clk),
    .rst(rst),
    .is_number(is_number),
    .is_enter(is_enter), 
    .state(state),
    .sel(sel) //output
);
calculator U_CAL(
    .clk(clk),
    .rst(rst),
    .dig0(dig0),
    .dig1(dig1),
    .dig2(dig2),
    .dig3(dig3),
    .is_add(is_add), 
    .is_subtract(is_subtract), 
    .is_multiple(is_multiple), 
    .is_neg(is_neg),
    .result(result)
);
bin2bcd U_BIN2BCD(
    .bin(result),
    .bcd( {re_dig3, re_dig2, re_dig1, re_dig0} )
);

wire [3:0] show0,show1,show2,show3;
always@(*) begin
    if(sel==3'd6)
        {show3,show2,show1,show0} = {re_dig3, re_dig2, re_dig1, re_dig0};
    else
        {show3,show2,show1,show0} = {dig3, dig2, dig1, dig0};
end

//**************************************************************
// Display block
wire clk_d;
wire [1:0] ssd_ctl_en;
wire [3:0] ssd_in;
freqdiv27 U_FD(
    .clk_out(clk_d), // divided clock
    .clk_ctl(ssd_ctl_en), // divided clock for scan control 
    .clk(clk), // clock from the crystal
    .rst_n(~rst) // low active reset
);
scan_ctl U_SCAN(
  .ssd_ctl(ssd_ctl), // ssd display control signal 
  .ssd_in(ssd_in), // output to ssd display
  .in0(show0), // 1st input
  .in1(show1), // 2nd input
  .in2(show2), // 3rd input
  .in3(show3),  // 4th input
  .ssd_ctl_en(ssd_ctl_en) // divided clock for scan control
);

// binary to 7-segment display decoder
display U_display(
  .segs(segs), // 7-segment display output
  .bin(ssd_in)  // BCD number input
);
endmodule