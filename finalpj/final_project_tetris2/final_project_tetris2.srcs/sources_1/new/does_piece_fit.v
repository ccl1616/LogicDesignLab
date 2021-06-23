`include "global.vh"

module does_piece_fit(
    input clk,
    input rst,
    input [31:0] currentRotate,
    input [31:0] currentPiece,
    input signed [31:0] currentX,
    input signed [31:0] currentY,
    input [199:0] map,
//    output [31:0] debug_x,
//    output [31:0] debug_y,
    output fit
);
    integer px;
    integer py;

    //reg [15:0] tetris_map [0:5];
/*
    reg [15:0] tetris_map [0:5] = {
        16'b0010001000100010,
        16'b0010011000100000,
        16'b0000011001100000,
        16'b0010011001000000,
        16'b0100011000100000,
        16'b0100010001100000,
        16'b0010001001100000
    };
*/
/*
    reg [6:0][15:0]tetris_map = {
        16'b0010001000100010,
        16'b0010011000100000,
        16'b0000011001100000,
        16'b0010011001000000,
        16'b0100011000100000,
        16'b0100010001100000,
        16'b0010001001100000
    };
*/
    reg [111:0] fuck_verilog = 112'b0000011101000000000001000111000000000110001100000000001101100000000001100110000000000111001000000000111100000000;

    reg signed [31:0] _x;
    reg signed [31:0] _y;
 //   assign debug_x = _x;
 //   assign debug_y = _y;

    wire [31:0] rotate_index;
    rotate _rotate(
        .clk(clk),
        .rst(rst),
        .px(_x),
        .py(_y),
        .type(currentRotate),
        .rotate_index(rotate_index)
    );

    reg [15:0] return;

    always @(posedge clk, posedge rst) begin
    //always @(*) begin
        if (rst) begin
            return <= 16'b1111111111111111; 
            _x <= 0;
            _y <= 0;
        end
        else begin
            if (_x < 4 && _y < 3) begin
                if (currentX + _x >= 0 && currentX + _x < `WIDTH) begin
                    if (currentY + _y >= 0 && currentY + _y < `HEIGHT) begin
                        //if (tetris_map[currentPiece][rotate_index] != 0 && 
                        if (fuck_verilog[(currentPiece%7)*16+rotate_index] == 1 && 
                            map[`HEIGHT*(currentX + _x) + currentY + _y] == 1) begin
                            return[4*_x + _y] <= 1'b0;
                        end
                        else return[4*_x + _y] <= 1'b1;
                    end 
                    else begin
                        if (fuck_verilog[(currentPiece%7)*16+rotate_index] == 1) return[4*_x + _y] <= 1'b0;
                        else return[4*_x + _y] <= 1'b1;
                    end
                end
                else begin
                    if (fuck_verilog[(currentPiece%7)*16+rotate_index] == 1) return[4*_x + _y] <= 1'b0;
                    else return[4*_x + _y] <= 1'b1;
                end
                _y <= _y + 1; 
            end
            else if (_x < 3 && _y == 3) begin
                if (currentX + _x >= 0 && currentX + _x < `WIDTH) begin
                    if (currentY + _y >= 0 && currentY + _y < `HEIGHT) begin
                        //if (tetris_map[currentPiece][rotate_index] != 0 && 
                        if (fuck_verilog[(currentPiece%7)*16+rotate_index] == 1 && 
                            map[`HEIGHT*(currentX + _x) + currentY + _y] == 1) begin
                            return[4*_x + _y] <= 1'b0;
                        end
                        else return[4*_x + _y] <= 1'b1;
                    end 
                    else begin
                        if (fuck_verilog[(currentPiece%7)*16+rotate_index] == 1) return[4*_x + _y] <= 1'b0;
                        else return[4*_x + _y] <= 1'b1;
                    end
                end
                else begin
                    if (fuck_verilog[(currentPiece%7)*16+rotate_index] == 1) return[4*_x + _y] <= 1'b0;
                    else return[4*_x + _y] <= 1'b1;
                end
                _x <= _x + 1; 
                _y <= 0;
            end
            else begin
                if (currentX + _x >= 0 && currentX + _x < `WIDTH) begin
                    if (currentY + _y >= 0 && currentY + _y < `HEIGHT) begin
                        //if (tetris_map[currentPiece][rotate_index] != 0 && 
                        if (fuck_verilog[(currentPiece%7)*16+rotate_index] == 1 && 
                            map[`HEIGHT*(currentX + _x) + currentY + _y] == 1) begin
                            return[4*_x + _y] <= 1'b0;
                        end
                        else return[4*_x + _y] <= 1'b1;
                    end 
                    else begin
                        if (fuck_verilog[(currentPiece%7)*16+rotate_index] == 1) return[4*_x + _y] <= 1'b0;
                        else return[4*_x + _y] <= 1'b1;
                    end
                end
                else begin
                    if (fuck_verilog[(currentPiece%7)*16+rotate_index] == 1) return[4*_x + _y] <= 1'b0;
                    else return[4*_x + _y] <= 1'b1;
                end
                _x <= 0; 
                _y <= 0;
            end
        end
    end

    assign fit = (return == 16'b1111111111111111) ? 1'b1 : 1'b0;
    


endmodule 