module rotate (
    input clk,
    input rst, 
    input signed [31:0] px,
    input signed [31:0] py,
    input [31:0] type,
    output reg signed [31:0] rotate_index
    //output reg block
);
    //reg [111:0] fuck_verilog = 112'b0000011101000000000001000111000000000110001100000000001101100000000001100110000000000111001000000000111100000000;

    always @(*) begin
        if (type % 4 == 0) begin
            rotate_index = 4*px + py;
            //block = fuck_verilog[10];
        end 
        else if (type % 4 == 1) begin
            rotate_index = 4*py + 3 - px;
            //block = fuck_verilog[4*py + 3 - px];
        end 
        else if (type % 4 == 2) begin 
            rotate_index = 15 - 4*px - py;
            //block = fuck_verilog[15 - px - py];
        end 
        else if (type % 4 == 3) begin
            rotate_index = 12 - 4*py + px;
            //block = fuck_verilog[12 - 4*py + px];
        end 
        else begin
            rotate_index = 0;
            //block = fuck_verilog[0];
        end
    end
endmodule