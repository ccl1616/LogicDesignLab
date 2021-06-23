`include "global.vh"
//------------------color----------------------//
`define BLACK   12'h0
`define WHITE   12'hfff
`define YELLOW  12'hff0
`define RED     12'hf00
`define GREEN   12'h0f0
`define BLUE    12'h00f
`define GRAY    12'h888

module mem_addr_gen(
    input clk,
    input rst,
    input[199:0] map_1,
    input[199:0] map_2,
    input [4:0] state_1,
    input [4:0] state_2,
    input [9:0] h_cnt,
    input [9:0] v_cnt,
    output [16:0] pixel_addr,
    output [11:0] pixel_color
);
    
    // scroll up
    assign pixel_addr = ((h_cnt>>1)+320*(v_cnt>>1))% 76800;  //640*480 --> 320*240 

//    reg [199:0] test = 200'd31;

    reg [11:0] color = 12'h0;
    always @(*) begin
        if (state_1 == `INI) begin
            color = `WHITE;
        end
        else if (state_1 == `FAIL) begin
            color = `BLACK;
        end
        else begin
            // left play ground 
            if (13 <= h_cnt && h_cnt <= 212 && 67 <= v_cnt && v_cnt <= 466) begin
                if (map_1[20*((h_cnt-13)/20)+((v_cnt-67)/20)] == 1'b1) color = `RED;
                else color = `YELLOW;
            end
            else if (400 <= h_cnt && h_cnt <= 599 && 67 <= v_cnt && v_cnt <= 466) begin
                if (map_2[20*((h_cnt-400)/20)+((v_cnt-67)/20)] == 1'b1) color = `BLUE;
                else color = `GRAY;
            end
            else color = `BLACK;        

        end
    end
    assign pixel_color = color;
       
endmodule
