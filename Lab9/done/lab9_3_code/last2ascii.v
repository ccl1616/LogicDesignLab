`define A 8'd65
`define B 8'd66
`define C 8'd67
`define D 8'd68
`define E 8'd69
`define F 8'd70
`define G 8'd71
`define H 8'd72
`define I 8'd73
`define J 8'd74
`define K 8'd75
`define L 8'd76
`define M 8'd77
`define N 8'd78
`define O 8'd79
`define P 8'd80
`define Q 8'd81
`define R 8'd82
`define S 8'd83
`define T 8'd84
`define U 8'd85
`define V 8'd86
`define W 8'd87
`define X 8'd88
`define Y 8'd89
`define Z 8'd90

module last2ascii(
    input clk,
    input rst,
    input [8:0]last_change,
    output reg [7:0]ascii
);
always@(*)begin
    case(last_change)
        9'h1C : ascii = `A;
        9'h32 : ascii = `B;
        9'h21 : ascii = `C;
        9'h23 : ascii = `D;
        9'h24 : ascii = `E;
        9'h2B : ascii = `F;
        9'h34 : ascii = `G;
        9'h33 : ascii = `H;
        9'h43 : ascii = `I;
        9'h3B : ascii = `J;
        9'h42 : ascii = `K;
        9'h4B : ascii = `L;
        9'h3A : ascii = `M;
        9'h31 : ascii = `N;
        9'h44 : ascii = `O;
        9'h4D : ascii = `P;
        9'h15 : ascii = `Q;
        9'h2D : ascii = `R;
        9'h1B : ascii = `S;
        9'h2C : ascii = `T;
        9'h3C : ascii = `U;
        9'h2A : ascii = `V;
        9'h1D : ascii = `W;
        9'h22 : ascii = `X;
        9'h35 : ascii = `Y;
        9'h1A : ascii = `Z;
        default : ascii = 8'd0;
    endcase
end
endmodule