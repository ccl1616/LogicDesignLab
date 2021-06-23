`include "global.vh"

module clear_line_drop (
    input clk,
    input rst,
    input [199:0] now_map,
    output [199:0] clear_line_drop_map
);

    reg [199:0] map;
    reg flag = 1'b0;
    reg signed [31:0] __y;
    reg [199:0] detect_now_input_map;

    always @(posedge clk, posedge rst) begin
        if (rst) begin
            map <= 200'b0;
            __y <= `HEIGHT - 1;
            flag <= 1'b0;
            detect_now_input_map <= 200'b0;
        end
        else begin
            if (detect_now_input_map != now_map) begin
                map <= now_map;
                __y <= `HEIGHT - 1;
                flag <= 0;
                detect_now_input_map <= now_map;
            end
            else if (__y > 0) begin
                if ((map[__y]&map[__y+20]&map[__y+40]&map[__y+60]&
                    map[__y+80]&map[__y+100]&map[__y+120]&map[__y+140]&
                    map[__y+160]&map[__y+180]) || flag == 1'b1) begin
                    flag <= 1'b1;
                    map[__y] <= map[__y-1];
                    map[__y+20] <= map[__y+19];
                    map[__y+40] <= map[__y+39];
                    map[__y+60] <= map[__y+59];
                    map[__y+80] <= map[__y+79];
                    map[__y+100] <= map[__y+99];
                    map[__y+120] <= map[__y+119];
                    map[__y+140] <= map[__y+139];
                    map[__y+160] <= map[__y+159];
                    map[__y+180] <= map[__y+179]; 
                end
                else begin
                    flag <= 1'b0;
                    map[__y] <= map[__y];
                    map[__y+20] <= map[__y+20];
                    map[__y+40] <= map[__y+40];
                    map[__y+60] <= map[__y+60];
                    map[__y+80] <= map[__y+80];
                    map[__y+100] <= map[__y+100];
                    map[__y+120] <= map[__y+120];
                    map[__y+140] <= map[__y+140];
                    map[__y+160] <= map[__y+160];
                    map[__y+180] <= map[__y+180]; 
                end
                __y <= __y - 1;
            end 
            else if (__y == 0) begin
                if ((map[__y]&map[__y+20]&map[__y+40]&map[__y+60]&
                    map[__y+80]&map[__y+100]&map[__y+120]&map[__y+140]&
                    map[__y+160]&map[__y+180]) || flag == 1'b1) begin

                    flag <= 1'b0;
                    map[__y] <= 0;
                    map[__y+20] <= 0;
                    map[__y+40] <= 0;
                    map[__y+60] <= 0;
                    map[__y+80] <= 0;
                    map[__y+100] <= 0;
                    map[__y+120] <= 0;
                    map[__y+140] <= 0;
                    map[__y+160] <= 0;
                    map[__y+180] <= 0; 
                end
                else begin
                    flag <= 1'b0;
                    map[__y] <= map[__y];
                    map[__y+20] <= map[__y+20];
                    map[__y+40] <= map[__y+40];
                    map[__y+60] <= map[__y+60];
                    map[__y+80] <= map[__y+80];
                    map[__y+100] <= map[__y+100];
                    map[__y+120] <= map[__y+120];
                    map[__y+140] <= map[__y+140];
                    map[__y+160] <= map[__y+160];
                    map[__y+180] <= map[__y+180]; 
                end
                __y <= `HEIGHT - 1;
            end
            else begin
                flag <= 1'b0;
                __y <= `HEIGHT - 1;
            end
        end
    end
    assign clear_line_drop_map = map;

endmodule