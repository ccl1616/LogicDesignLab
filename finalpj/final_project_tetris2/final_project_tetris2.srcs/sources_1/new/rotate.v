module rotate (
    input clk,
    input rst, 
    input signed [31:0] px,
    input signed [31:0] py,
    input [31:0] type,
    output reg signed [31:0] rotate_index
    //output reg block
);
    
    always @(*) begin
        if (type % 4 == 0) begin
            rotate_index = 4*px + py;
        end 
        else if (type % 4 == 1) begin
            rotate_index = 4*py + 3 - px;
        end 
        else if (type % 4 == 2) begin 
            rotate_index = 15 - 4*px - py;
        end 
        else if (type % 4 == 3) begin
            rotate_index = 12 - 4*py + px;
        end 
        else begin
            rotate_index = 0;
        end
    end
endmodule