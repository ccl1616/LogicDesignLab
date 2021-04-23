`include "global.v"
module top(
    switch,
    pb_r,
    pb_l,
    pb_mode,
    clk,
    rst_n,
    led,
    segs, // 7 segment display control
    ssd_ctl // scan control for 7-segment display
);
output [15:0]led;
output [`SSD_BIT_WIDTH-1:0] segs; // 7 segment display control
output [`SSD_DIGIT_NUM-1:0] ssd_ctl; // scan control for 7-segment display
input clk; // clock
input rst_n; // low active reset
input switch,pb_r,pb_l,pb_mode;
wire switch_o,pb_r_o,pb_l_o,pb_l_long_o,pb_mode_o;
wire pb_ldb,pb_rdb;
// seg
wire [`SSD_SCAN_CTL_BIT_WIDTH-1:0] ssd_ctl_en; // divided output for ssd scan control

// fsm
wire [2:0]state;
wire fsm_down_en,fsm_up_en,fsm_load_en,fsm_nowlap,fsm_rst;

// counter
wire count_enable; // if count is enabled
reg [`BCD_BIT_WIDTH-1:0] dig0,dig1,dig2,dig3; // second counter output
wire [`BCD_BIT_WIDTH-1:0] ssd_in; // input to 7-segment display decoder
assign all_zero = ( {dig3,dig2,dig1,dig0}==4'd0 ) ?1'b1 :1'b0;
// freq
wire clk_d; // divided clock
wire clk_100;
wire clk_1;
wire tick_1;
// led
wire [15:0]led;
assign led[2:0] = (all_zero)?3'b111:state ;
assign led[15:3] = (all_zero == 1'b1)?13'b1_1111_1111_1111:13'b0;

// freq
assign tick_counting = (state!=3'd2)&(state!=3'd4);
assign tick_load = (state==3'd0)| ( (state==3'd4)&(fsm_rst==1'b1) );
clock_generator U_CG(
    .clk(clk), // clock from crystal
    .rst_n(rst_n), // active low reset
    .clk_1(clk_1), // generated 1 Hz clock
    .clk_100(clk_100) // generated 100 Hz clock
);
freqdiv27 U_FD(
    .clk_out(clk_d), // divided clock
    .clk_ctl(ssd_ctl_en), // divided clock for scan control 
    .clk(clk), // clock from the crystal
    .rst_n(rst_n) // low active reset
);
tick U_TICK(
    .clk(clk_100),
    .rst_n(rst_n),
    .initval(`DIV_BY_100_BIT_WIDTH'd0),
    .enable(tick_counting ),
    .load(tick_load),
    // output
    .tick(tick_1)
);

// pb
interface U_INTER(
    .clk(clk_100),
    .rst_n(rst_n),
    .switch(switch),
    .pb_l(pb_l),
    .pb_r(pb_r),
    .pb_mode(pb_mode),
    // output 
    .switch_o(switch_o),
    .pb_l_o(pb_l_o),
    .pb_l_long_o(pb_l_long_o),
    .pb_r_o(pb_r_o),
    .pb_ldb(pb_ldb),
    .pb_rdb(pb_rdb),
    .pb_mode_o(pb_mode_o)
);
//**************************************************************
// fsm
fsm U_FSM(
    .clk(clk_100),
    .rst_n(rst_n),
    .switch(switch_o),
    .pb_mode(pb_mode_o),
    .pb_l(pb_l_o), 
    .pb_l_long(pb_l_long_o),
    .pb_r(pb_r_o),
    .all_zero(all_zero),
    // output
    .rst(fsm_rst),
    .load_en(fsm_load_en),
    .down_en(fsm_down_en),
    .up_en(fsm_up_en),
    .nowlap(nowlap),
    .state(state)
);

//**************************************************************
// counter
wire [3:0] setdigit0,setdigit1,setdigit2,setdigit3;
wire [3:0] downdigit0,downdigit1,downdigit2,downdigit3;
wire [3:0] updigit0,updigit1,updigit2,updigit3;
set_upcounter_4d U_SETCNT(
    .pbsec(pb_rdb&(state==3'd3)&(tick_1)),
    .pbmin(pb_ldb&(state==3'd3)&(tick_1)),
    .digit0(setdigit0),  // right most digit
    .digit1(setdigit1), 
    .digit2(setdigit2),
    .digit3(setdigit3),
    .clk(clk_100),  
    .rst_n(rst_n)  // low active reset
);
downcounter_4d U_DOWNCNT(
    .loadval0(setdigit0),
    .loadval1(setdigit1),
    .loadval2(setdigit2),
    .loadval3(setdigit3),
    .digit0(downdigit0),  // right most digit
    .digit1(downdigit1), 
    .digit2(downdigit2),
    .digit3(downdigit3),
    .clk(clk_100),  
    .rst_n(rst_n),  // low active reset
    .load_enable(fsm_load_en),
    .en(fsm_down_en&(tick_1))
);
lap_upcounter_4d U_UPCNT(
    .nowlap(nowlap),
    .digit0(updigit0),  // 2nd digit of the down counter
    .digit1(updigit1),  // 1st digit of the down counter
    .digit2(updigit2),
    .digit3(updigit3),
    .clk(clk_100),  // global clock
    .rst(fsm_rst),
    .rst_n(rst_n),  // low active reset
    .en(fsm_up_en&(tick_1)) // enable/disable for the stopwatch
);

always@*begin
    if(state == 3'd3)
        {dig3,dig2,dig1,dig0} = {setdigit3,setdigit2,setdigit1,setdigit0};
    else if(state==3'd4 | state==3'd5 | state==3'd6)
        {dig3,dig2,dig1,dig0} = {updigit3,updigit2,updigit1,updigit0};
    else 
        {dig3,dig2,dig1,dig0} = {downdigit3,downdigit2,downdigit1,downdigit0};
end


//**************************************************************
// Display block
// Scan control
scan_ctl U_SC(
  .ssd_ctl(ssd_ctl), // ssd display control signal 
  .ssd_in(ssd_in), // output to ssd display
  .in0(dig3), // 1st input
  .in1(dig2), // 2nd input
  .in2(dig1), // 3rd input
  .in3(dig0),  // 4th input
  .ssd_ctl_en(ssd_ctl_en) // divided clock for scan control
);

// binary to 7-segment display decoder
display U_display(
  .segs(segs), // 7-segment display output
  .bin(ssd_in)  // BCD number input
);
endmodule