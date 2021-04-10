`include "global.v"
module stopwatch_v2(
    led,
    segs, // 7 segment display control
    ssd_ctl, // scan control for 7-segment display
    clk, // clock
    rst_n, // low active reset
    pb_in
);

output [15:0]led;
output [`SSD_BIT_WIDTH-1:0] segs; // 7 segment display control
output [`SSD_DIGIT_NUM-1:0] ssd_ctl; // scan control for 7-segment display
input clk; // clock
input rst_n; // low active reset
input pb_in; // input control for FSM

wire [`SSD_SCAN_CTL_BIT_WIDTH-1:0] ssd_ctl_en; // divided output for ssd scan control
wire clk_d; // divided clock

wire count_enable; // if count is enabled

wire [`BCD_BIT_WIDTH-1:0] dig0,dig1; // second counter output
wire [`BCD_BIT_WIDTH-1:0] ssd_in; // input to 7-segment display decoder

wire fsm_rst, fsm_ps;

// led
wire [15:0]led;
wire state_o;
assign led[15:1] = ( {dig1,dig0}== 2'd0 )? 15'b111_1111_1111_1111 :15'b0;
assign led[0] = (state_o == 1'b1)? 1'b1 : ( ({dig1,dig0} == 2'd00)? 1'b1 :1'b0 );

// pulse
wire led_1; // 1Hz divided clock
wire clk_100;
wire led_pb0; // after debounced
clock_generator U_cg(
  .clk(clk), // clock from crystal
  .rst_n(rst_n), // active low reset
  .clk_1(led_1), // generated 1 Hz clock
  .clk_100(clk_100) // generated 100 Hz clock
);
// debounce circuit
debounce_circuit U_dc0(
  .clk(clk_100), // clock control
  .rst_n(rst_n), // reset
  .pb_in(pb_in), //push button input
  .pb_debounced(led_pb0) // debounced push button output
);
// press
preff U_p(
    .mode_in(led_pb0),
    .long_press(fsm_rst),
    .short_press(fsm_ps),
    .rst_n(rst_n),
    .clk(clk_100)
);

// FSM
fsm U_fsm(
  .state_o(state_o),
  .in0(fsm_rst), // input control
  .in1(fsm_ps),
  .rst(rst), // output rst stopwatch
  .count_enable(count_enable),  // if counter is enabled 
  .clk(clk_100), // global clock signal
  .rst_n(rst_n)  // low active reset
);

// frequency divider 1/(2^27)
freqdiv27 U_FD(
  .clk_out(clk_d), // divided clock
  .clk_ctl(ssd_ctl_en), // divided clock for scan control 
  .clk(clk), // clock from the crystal
  .rst_n(rst_n) // low active reset
);

// stopwatch module
downcounter_2d U_sw(
  .digit1(dig1),  // 2nd digit of the down counter
  .digit0(dig0),  // 1st digit of the down counter
  .clk(clk_d),  // global clock
  .rst(rst),
  .rst_n(rst_n),  // low active reset
  .en(count_enable) // enable/disable for the stopwatch
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
  .in0(4'b0000), // 1st input
  .in1(4'b0000), // 2nd input
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