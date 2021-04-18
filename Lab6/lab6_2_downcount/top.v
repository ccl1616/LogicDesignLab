`include "global.v"
module top(
    switch,
    pbsec,
    pbmin,
    pbpause,
    pbstart,
    clk,
    rst_n,
    led,
    segs, // 7 segment display control
    ssd_ctl, // scan control for 7-segment display
);
output [15:0]led;
output [`SSD_BIT_WIDTH-1:0] segs; // 7 segment display control
output [`SSD_DIGIT_NUM-1:0] ssd_ctl; // scan control for 7-segment display
input clk; // clock
input rst_n; // low active reset
input switch,pbsec,pbmin,pbpause,pbstart;
wire switch_o,pbsec_o,pbmin_o,pbpause_o,pbstart_o;
// seg
wire [`SSD_SCAN_CTL_BIT_WIDTH-1:0] ssd_ctl_en; // divided output for ssd scan control

// fsm
wire [2:0]state;
wire fsm_en,fsm_load_en;

// counter
wire count_enable; // if count is enabled
reg [`BCD_BIT_WIDTH-1:0] dig0,dig1,dig2,dig3; // second counter output
wire [`BCD_BIT_WIDTH-1:0] ssd_in; // input to 7-segment display decoder

// led
wire [15:0]led;
assign led[15:3] = ( {dig3,dig2,dig1,dig0}==4'd0 )? 13'b1_1111_1111_1111 :13'b0;
assign led[2:0] = state;

// freq
wire clk_d; // divided clock
wire clk_100;
wire clk_1;

// freq
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

// pb
interface U_INTER(
    .clk(clk_100),
    .rst_n(rst_n),
    .switch(switch),
    .pbsec(pbsec),
    .pbmin(pbmin),
    .pbpause(pbpause),
    .pbstart(pbstart),
    .switch_o(switch_o),
    .pbsec_o(pbsec_o),
    .pbmin_o(pbmin_o),
    .pbpause_o(pbpause_o),
    .pbstart_o(pbstart_o)
);
//**************************************************************
// fsm
wire all_zero = ( {dig3,dig2,dig1,dig0}==4'd0 ) ?1'b0 :1'b0;
fsm U_FSM(
    .pb_ps(pbpause_o),
    .pb_start(pbstart_o),
    .switch(switch_o),
    .clk(clk_100),
    .rst_n(rst_n),
    .all_zero(all_zero),
    .count_enable(fsm_en),
    .load_enable(fsm_load_en),
    .state(state)
);

//**************************************************************
// counter
wire setdigit0,setdigit1,setdigit2,setdigit3;
wire showdigit0,showdigit1,showdigit2,showdigit3;
upcounter_4d U_UC4D(
    .pbsec(pbsec_o),
    .pbmin(pbmin_o),
    .state(state),
    .digit0(setdigit0),  // right most digit
    .digit1(setdigit1), 
    .digit2(setdigit2),
    .digit3(setdigit3),
    .clk(clk_d),  
    .rst_n(clk_d)  // low active reset
);
downcounter_4d U_DC4D(
    .loadval0(setdigit0),
    .loadval1(setdigit1),
    .loadval2(setdigit2),
    .loadval3(setdigit3),
    .digit0(showdigit0),  // right most digit
    .digit1(showdigit0), 
    .digit2(showdigit0),
    .digit3(showdigit0),
    .clk(clk_d),  
    .rst_n(clk_d),  // low active reset
    .load_enable(fsm_load_en),
    .en(fsm_en)
);
always@*begin
    if(state == 3'b011)
        {dig3,dig2,dig1,dig0} = {setdigit3,setdigit2,setdigit1,setdigit0};
    else 
        {dig3,dig2,dig1,dig0} = {showdigit3,showdigit2,showdigit1,showdigit0};
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