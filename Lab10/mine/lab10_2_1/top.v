`include "global.v"
module top10_2(
    inout wire PS2_DATA,
    inout wire PS2_CLK,
    input wire rst,
    input wire clk,
    output wire [3:0] ssd_ctl,
    output wire [7:0] segs,
    output wire [15:0] led,
    // vga related
    output [3:0] vgaRed,
    output [3:0] vgaGreen,
    output [3:0] vgaBlue,
    output hsync,
    output vsync
);

//**************************************************************
// calculator
wire [2:0]state;
wire [3:0] char;
wire flag;
wire is_neg;
assign led[3:0] = char;
assign led[6:4] = state;
assign led[15] = is_neg;

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

wire [7:0]ascii;
last2ascii U_L2A(
    .clk(clk),
    .rst(rst),
    .last_change(last_change),
    .ascii(ascii)
);
//**************************************************************
// calculate app
wire [3:0] show0,show1,show2,show3;
calculator_app U_CAL(
    .clk(clk),
    .rst(rst),
    .ascii(ascii),
    .newkey(key_down_op),
    .show0(show0),
    .show1(show1),
    .show2(show2),
    .show3(show3),
    .state(state),
    .is_neg(is_neg)
);

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
  .in0(show3), // 1st input
  .in1(show2), // 2nd input
  .in2(show1), // 3rd input
  .in3(show0),  // 4th input
  .ssd_ctl_en(ssd_ctl_en) // divided clock for scan control
);

// binary to 7-segment display decoder
display U_display(
  .segs(segs), // 7-segment display output
  .bin(ssd_in)  // BCD number input
);
//============================================================================================
// vga

// pre work
wire clk_25MHz;
wire valid;
wire [9:0] h_cnt; //640
wire [9:0] v_cnt;  //480
wire font_bit;
wire [3:0] vgaRed_2;

clock_divisor clk_wiz_0_inst(
  .clk(clk),
  .clk1(clk_25MHz)
);

// bcd 2 ascii
wire [7:0]as0,as1,as2,as3;
bcd2asc U0_bcd2as(
    .bcd(show0),
    .ascii(as0)
);
bcd2asc U1_bcd2as(
    .bcd(show1),
    .ascii(as1)
);
bcd2asc U2_bcd2as(
    .bcd(show2),
    .ascii(as2)
);
bcd2asc U3_bcd2as(
    .bcd(show3),
    .ascii(as3)
);

// 25M op
wire newkey_op_25M;
one_pulse U_OP25M(
  .clk(clk_25MHz),  // clock input
  .rst_n(~rst), //active low reset
  .in_trig(key_down[last_change]), // input trigger
  .out_pulse(newkey_op_25M)
);

// fsm
wire state_ram;
wire we;
wire [`ADDR_WIDTH-1:0] addr_r, addr_w;
wire [`DATA_WIDTH-1:0] din,dout;
wire [7:0]font_word;

fsm_ram fsm_ram(
    .clk(clk_25MHz),
    .rst(rst),
    .as0(as0),
    .as1(as1),
    .as2(as2),
    .as3(as3),
    .newkey_op(newkey_op_25M),
    .we(we),
    .addr_w(addr_w),
    .data(din),
    .state(state_ram)
);

// vga related
vga_controller   vga_inst(
  .pclk(clk_25MHz),
  .reset(rst),
  .hsync(hsync),
  .vsync(vsync),
  .valid(valid),
  .h_cnt(h_cnt),
  .v_cnt(v_cnt)
);
assign vgaRed = font_bit ?( valid?4'hf:4'h0):4'h0;
assign vgaGreen = 4'h0;
assign vgaBlue = 4'h0;

// tile related
// char generator
sync_rw_port_ram U_ram(
    .clk(clk),
    .we(we),
    .addr_r( { (v_cnt>>1)[9:4],(h_cnt>>1)[9:3]} ),
    .addr_w(addr_w),
    .din(din),
    .dout(dout)
);

font_rom U_font_rom(
    .clk(clk),
    .addr( {dout,(v_cnt>>1)[3:0]} ),
    .data(font_word)
);

wire [2:0]bit_addr = ~( (h_cnt>>1)[2:0] );
reg [2:0]bit_addr_delay1, bit_addr_delay2;
always@(posedge clk)
    bit_addr_delay1 <= bit_addr;
always@(posedge clk)
    bit_addr_delay2 <= bit_addr_delay1;

assign font_bit = font_word[bit_addr_delay2];

endmodule