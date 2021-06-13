`include "global.vh"
module display(
    input clk,
    input rst,
    input [199:0] map_1,
    input [199:0] map_2,
    input [4:0] state_1,
    input [4:0] state_2,
    input [31:0] hard_1,
    input [31:0] hard_2,
    output [3:0] vgar,
    output [3:0] vgag,
    output [3:0] vgab,
    output h_sync,
    output v_sync
);


    wire valid;
    wire [11:0] data;
    wire [9:0] h_cnt; //640
    wire [9:0] v_cnt;  //480
    wire [11:0] pixel;
    wire [16:0] pixel_addr;
    wire [11:0] pixel_color;

    assign {vgar, vgag, vgab} = (valid==1'b1) ? (state_1 == `INI) ? pixel : pixel_color :12'h0;
    //assign {vgar, vgag, vgab} = (valid==1'b1) ? pixel_color :12'h0;
    //assign {vgaRed, vgaGreen, vgaBlue} = (valid==1'b1) ? pixel :12'h0;

    wire clk_show;
    clock_divider #(.n(2)) show_clk(
        .clk(clk),
        .clk_div(clk_show)
    );
    mem_addr_gen pixel_gen_inst(
        .clk(clk_show),
        .rst(rst),
        .map_1(map_1),
        .map_2(map_2),
        .state_1(state_1),
        .state_2(state_2),
        .h_cnt(h_cnt),
        .v_cnt(v_cnt),
        .pixel_addr(pixel_addr),
        .pixel_color(pixel_color)
    );

    blk_mem_gen_0 blk_mem_gen_0_inst(
      .clka(clk_show),
      .wea(0),
      .addra(pixel_addr),
      .dina(data[11:0]),
      .douta(pixel)
    ); 

    vga_controller   vga_inst(
        .pclk(clk_show),
        .reset(rst),
        .valid(valid),
        .hsync(h_sync),
        .vsync(v_sync),
        .h_cnt(h_cnt),
        .v_cnt(v_cnt)
    );
      
endmodule