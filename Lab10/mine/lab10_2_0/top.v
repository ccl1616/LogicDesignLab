module top(
  input clk,
  input rst,
  input [15:0] sw,
  output [3:0] vgaRed,
  output [3:0] vgaGreen,
  output [3:0] vgaBlue,
  output hsync,
  output vsync
);


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

/*
pixel_gen pixel_gen_inst(
  .h_cnt(h_cnt),
  .valid(valid),
  .vgaRed(vgaRed),
  .vgaGreen(vgaGreen),
  .vgaBlue(vgaBlue)
);
*/

vga_controller   vga_inst(
  .pclk(clk_25MHz),
  .reset(rst),
  .hsync(hsync),
  .vsync(vsync),
  .valid(valid),
  .h_cnt(h_cnt),
  .v_cnt(v_cnt)
);

tile tile(
  .clk(clk_25MHz),
  .rst(rst),
  .pixel_x(h_cnt>>1),
  .pixel_y(v_cnt>>1),
  .font_bit(font_bit)
);
assign vgaRed = font_bit ? sw[3:0]:4'h0;
assign vgaGreen = font_bit ? sw[7:4]:4'h0;
assign vgaBlue = font_bit ? sw[11:8]:4'h0;
      
endmodule
