`include "global.v"
// 25sec stopwatch
module stopwatch(
  // outputs
  segs, // 7 segment display control
  ssd_ctl, // scan control for 7-segment display
  led0,
  led1,
  // inputs
  clk, // clock
  rst_n, // low active reset
  pb_in0, // btn for reset stopwatch
  pb_in1 // btn for pause/start
);

output [`SSD_BIT_WIDTH-1:0] segs; // 7 segment display control
output [`SSD_DIGIT_NUM-1:0] ssd_ctl; // scan control for 7-segment display
output led0;
output led1;
input clk; // clock
input rst_n; // low active reset
input pb_in0; 
input pb_in1;

// clkgen
wire [`SSD_SCAN_CTL_BIT_WIDTH-1:0] ssd_ctl_en; // divided output for ssd scan control
wire clk_100; // divided clock
wire clk_1;

// push btn
wire pb_d0;
wire pb_d1;
wire pulse0;
wire pulse1;

// fsm
wire rst;
wire count_enable; // if count is enabled

//downcount
wire [`BCD_BIT_WIDTH-1:0] dig0,dig1; // second counter output
// display
wire [`BCD_BIT_WIDTH-1:0] ssd_in; // input to 7-segment display decoder

//**************************************************************
// Functional block
//**************************************************************
// frequency divider
clkgen U_FD(
  .clk(clk), // clock from the crystal
  .rst_n(rst_n), // low active reset 
  // output
  .clk_100(clk_100), // divided clock
  .clk_1(clk_1),
  .clk_ctl(ssd_ctl_en) // divided clock for scan control 
);

// debounce
debounce_2d U_dc(
  .clk(clk_100), // clock control
  .rst_n(rst_n), // reset
  .pb_in0(pb_in0), //push button input
  .pb_in1(pb_in1),
  // output
  .pb_debounced0(pb_d0), // debounced push button output
  .pb_debounced1(pb_d1)
);

// 1 pulse generation circuit
onepulse_2d U_op(
  .clk(led_1),  // clock input
  .rst_n(rst_n), //active low reset
  .in_trig0(pb_d0), // input trigger
  .in_trig1(pb_d1),
  // output
  .out_pulse0(pulse0), // output one pulse 
  .out_pulse1(pulse1)
);

// finite state machine
fsm U_fsm(
  .clk(clk_d), // global clock signal
  .rst_n(rst_n),  // low active reset
  .in0(pulse0), //input control
  .in1(pulse1),
  // output
  .count_enable(count_enable),  // if counter is enabled 
  .rst(rst)
);

// stopwatch module
downcounter_2d U_sw(
  .clk(clk_1),  
  .rst_n(rst_n),  // low active reset
  .en(count_enable), // enable/disable for the stopwatch
  .rst(rst),
  // output
  .digit1(dig1),  // 2nd digit of the down counter
  .digit0(dig0)  // 1st digit of the down counter
);

//**************************************************************
// Display block
//**************************************************************
// BCD to 7-segment display decoding
// seven-segment display decoder for DISP1

// Scan control
scan_ctl U_SC(
  .ssd_ctl(ssd_ctl), // ssd display control signal 
  .ssd_in(ssd_in), // output to ssd display
  .in0(4'b1111), // 1st input
  .in1(4'b1111), // 2nd input
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
