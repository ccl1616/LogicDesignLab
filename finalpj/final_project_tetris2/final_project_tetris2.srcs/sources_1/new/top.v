`include "global.vh"

module top (
	input clk,
	input rst,
//------------------keyboard-------------------//
	inout wire PS2_DATA,
	inout wire PS2_CLK,
//------------------7 segment------------------//
	output wire [0:6] DISPLAY,
	output wire [3:0] DIGIT,
//--------------------LED----------------------//
	output wire [15:0] led,
//------------------switch---------------------//
	input wire [15:0] sw,
//------------------audio----------------------//
	output audio_mclk, // master clock
	output audio_lrck, // left-right clock
	output audio_sck, // serial clock
	output audio_sdin, // serial audio data input
	input wire _volUP, 
	input wire _volDOWN,
//-------------------VGA-----------------------//
    output [3:0] vgaRed,
    output [3:0] vgaGreen,
    output [3:0] vgaBlue,
    output hsync,
    output vsync	
);

//-----------------keyboard--------------------//
	wire [11:0] data;
	wire [511:0] key_down;
	wire [8:0] last_change;
	wire been_ready;
	KeyboardDecoder key_de (
		.key_down(key_down),
		.last_change(last_change),
		.key_valid(been_ready),
		.PS2_DATA(PS2_DATA),
		.PS2_CLK(PS2_CLK),
		.rst(rst),
		.clk(clk)
	);

	wire [199:0] map_player_1;
	wire [4:0] state_player_1;
	wire [31:0] score_player_1;
	wire [31:0] hard_player_1;
	wire [31:0] hard_player_2;
	wire fail_1;
	wire fail_2;
	tetris player_1 (
		.clk(clk),
		.rst(rst),
		.rotate(key_down[`KEY_ROTATE]),
		.down(key_down[`KEY_DOWN]),
		.right(key_down[`KEY_RIGHT]),
		.left(key_down[`KEY_LEFT]),
		.speed(sw[15]),
		.stop(sw[14]),
		.he_fail(fail_2),
		.my_hard(hard_player_1),
		.start(key_down[`KEY_ENTER]),
		.tetris_map(map_player_1),
		.state(state_player_1),
		.score(score_player_1),
		.other_hard(hard_player_2),
		.I_fail(fail_1)
	);

	wire [199:0] map_player_2;
	wire [4:0] state_player_2;
	wire [31:0] score_player_2;
	tetris player_2 (
		.clk(clk),
		.rst(rst),
		.rotate(key_down[`KEY_ROTATE_2]),
		.down(key_down[`KEY_DOWN_2]),
		.right(key_down[`KEY_RIGHT_2]),
		.left(key_down[`KEY_LEFT_2]),
		.speed(sw[15]),
		.stop(sw[14]),
		.he_fail(fail_1),
		.my_hard(hard_player_2),
		.start(key_down[`KEY_ENTER]),
		.tetris_map(map_player_2),
		.state(state_player_2),
		.score(score_player_2),
		.other_hard(hard_player_1),
		.I_fail(fail_2)
	);

	display show(
		.clk(clk),
		.rst(rst),
		.map_1(map_player_1),
		.map_2(map_player_2),
		.state_1(state_player_1),
		.state_2(state_player_2),
		.hard_1(hard_player_1),
		.hard_2(hard_player_2),
		.vgar(vgaRed),
		.vgag(vgaGreen),
		.vgab(vgaBlue),
		.h_sync(hsync),
		.v_sync(vsync)
	);

	segment debug (
		.clk(clk),
		.map(map_player_1),
		.score_1(score_player_1),
		.score_2(score_player_2),
		.fail_1(fail_1),
		.fail_2(fail_2),
		.key_set({key_down[`KEY_RIGHT], key_down[`KEY_ROTATE], key_down[`KEY_LEFT], key_down[`KEY_DOWN]}),
		._led(led),
		._digit(DIGIT),
		._display(DISPLAY)
	);

	wire fast_switch = sw[13] | sw[1];
	wire fast_player = (score_player_1 >= 32'd2 | score_player_2 >= 32'd2) ?1'b1:1'b0 ;
    my_music music(
        .clk(clk), 
        .rst(rst),
        .slow_fast(sw[15] | fast_switch | fast_player ),
        .audio_mclk(audio_mclk),
        .audio_lrck(audio_lrck),
        .audio_sck(audio_sck),
        .audio_sdin(audio_sdin)
);

endmodule
