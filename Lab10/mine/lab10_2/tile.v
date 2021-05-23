`define ADDR_WIDTH 13
`define DATA_WIDTH 7
module tile(
    input clk,
    input rst,
    input [9:0] pixel_x,
    input [9:0] pixel_y,
    output font_bit
);

wire [`ADDR_WIDTH-1:0] addr_r, addr_w;
wire [`DATA_WIDTH-1:0] din,dout;
wire [7:0]font_word;

// char gen
sync_rw_port_ram U_ram(
    .clk(clk),
    .we(we),
    .addr_r( {pixel_y[9:4],pixel_x[9:3]} ),
    .addr_w(addr_w),
    .din(din),
    .dout(dout)
);

font_rom U_font_rom(
    .clk(clk),
    .addr( {dout,pixel_y[3:0]} ),
    .data(font_word)
);

always@(*) begin
    case(pixel_x[2:0])
    3'd0: font_bit = font_word[0];
    3'd1: font_bit = font_word[1];
    3'd2: font_bit = font_word[2];
    3'd3: font_bit = font_word[3];

    3'd4: font_bit = font_word[4];
    3'd5: font_bit = font_word[5];
    3'd6: font_bit = font_word[6];
    3'd7: font_bit = font_word[7];
    default: font_bit = 0;
end
endmodule