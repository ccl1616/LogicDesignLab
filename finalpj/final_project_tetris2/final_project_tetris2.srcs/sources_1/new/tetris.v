`include "global.vh"

module tetris (
	input clk,
	input rst,
	input rotate,
	input down,
	input right,
	input left,
	input speed,
	input stop,
	input start,
	input he_fail,
	input [31:0] my_hard,
	output [199:0] tetris_map,
	output [4:0] state,
	output [31:0] score,
	output [31:0] other_hard,
	output I_fail
);

	wire [31:0] currentRotate;	
	wire [31:0] currentPiece;	
	wire signed [31:0] currentX;	
	wire signed [31:0] currentY;	
	wire [199:0] map;
	wire [199:0] pure_map;

	wire rotate_hold;
	wire force_down;
	wire _down;
	wire _right;
	wire _left;

	wire [4:0] __state;
	wire [31:0] __score;

	signal_gen sign (
		.clk(clk),
		.rst(rst),
		.rotate(rotate),
		.down(down),
		.right(right),
		.left(left),
		.speed(speed),
		.stop(stop),
		.start(start),
		.hard(my_hard),
		.he_fail(he_fail),
		.currentRotate(currentRotate),
		.currentPiece(currentPiece),
		.currentX(currentX),
		.currentY(currentY),
		.map(map),
		.pure_map(pure_map),
		.rotate_hold(rotate_hold),
		.force_down(force_down),
		._down(_down),
		._right(_right),
		._left(_left),
		._state(__state),
		.I_fail(I_fail)
	);

	do_something do(
		.clk(clk),
		.rst(rst),
		.rotate_hold(rotate_hold),
		.force_down(force_down),
		.down(_down),
		.right(_right),
		.left(_left),
		.state(__state),
		.currentRotate(currentRotate),
		.currentPiece(currentPiece),
		.currentX(currentX),
		.currentY(currentY),
		.map(map),
		.score(__score),
		.the_other_hard(other_hard),
		.pure_map(pure_map)
	);	
	assign tetris_map = map;
	assign state = __state;
	assign score = __score;

endmodule