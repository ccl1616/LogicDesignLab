`include "global.vh"

module gen_map (
    input clk,
    input rst,
    input [31:0] currentRotate,
    input [31:0] currentPiece,
    input signed [31:0] currentX,
    input signed [31:0] currentY,
    output [199:0] n_map
);


    integer _x ;
    integer _y ;

    reg [111:0] our_data = 112'b0000011101000000000001000111000000000110001100000000001101100000000001100110000000000111001000000000111100000000;

    wire [31:0] rotate_index;
    reg signed [31:0] __x;
    reg signed [31:0] __y;
    rotate _rotate (
        .clk(clk),
        .rst(rst),
        .px(__x - currentX),
        .py(__y - currentY),
        .type(currentRotate),
        .rotate_index(rotate_index)
    );

    reg [199:0] map;

    always @(posedge clk, posedge rst) begin
        if (rst) begin
            map <= 200'd0;
            __x <= 32'd0;
            __y <= 32'd0;
        end 
        else begin
            if (__x < `WIDTH && __y < `HEIGHT - 1) begin
                if ((currentX <= __x && __x <= currentX+3) &&
                    (currentY <= __y && __y <= currentY+3) ) begin
                    map[`HEIGHT*__x + __y] <= our_data[(currentPiece%7)*16+rotate_index];
                end
                else begin
                    map[`HEIGHT*__x + __y] <= 0;
                end
                __y <= __y + 1;
            end 
            else if (__x < `WIDTH - 1 && __y == `HEIGHT - 1) begin
                if ((currentX <= __x && __x <= currentX+3) &&
                    (currentY <= __y && __y <= currentY+3) ) begin
                    map[`HEIGHT*__x + __y] <= our_data[(currentPiece%7)*16+rotate_index];
                end
                else begin
                    map[`HEIGHT*__x + __y] <= 0;
                end
                __x <= __x + 1;
                __y <= 0;
            end
            else begin
                if ((currentX <= __x && __x <= currentX+3) &&
                    (currentY <= __y && __y <= currentY+3) ) begin
                    map[`HEIGHT*__x + __y] <= our_data[(currentPiece%7)*16+rotate_index];
                end
                else begin
                    map[`HEIGHT*__x + __y] <= 0;
                end
                __x <= 0;
                __y <= 0;
            end
        end
    end

    
    assign n_map = map;
endmodule