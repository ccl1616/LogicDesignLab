//----------------7 ssegment-------------------//
`define ZERO    7'b0000001
`define ONE     7'b1001111 
`define TWO     7'b0010010 
`define THREE   7'b0000110
`define FOUR    7'b1001100 
`define FIVE    7'b0100100 
`define SIX     7'b0100000 
`define SEVEN   7'b0001111
`define EIGHT   7'b0000000
`define NINE    7'b0000100 
`define NOTHING 7'b1111111 


module segment (
    input clk,
    input [199:0] map,
    input [3:0] key_set,
    input [31:0] score_1,
    input [31:0] score_2,
    input fail_1,
    input fail_2,
    output reg [15:0] _led,
    output [3:0] _digit,
    output [6:0] _display
);

    wire clk_segment;
    clock_divider  #(.n(13)) showclk (.clk(clk), .clk_div(clk_segment));
    
    reg [3:0] digit = 4'b1110;
    reg [3:0] next_digit = 4'b1110;
    reg [6:0] display = `ZERO;
    reg [6:0] next_display = `ZERO;

    reg [3:0] temp_value = 4'b0000;
    always @(posedge clk_segment) begin
        display <= next_display;
        digit <= next_digit;
    end

    always @(*)begin
        case (digit)
            4'b1110:begin 
                //temp_value = bcd[7:4];
                temp_value = score_2/10;
                next_digit = {digit[2:0], digit[3]};
            end
            4'b1101:begin
                //temp_value = bcd[11:8];
                temp_value = score_1%10;
                next_digit = {digit[2:0], digit[3]};
            end
            4'b1011:begin
                //temp_value = bcd[15:12];
                temp_value = score_1/10;
                next_digit = {digit[2:0], digit[3]};
            end
            4'b0111:begin
                //temp_value = bcd[3:0];
                temp_value = score_2%10;
                next_digit = {digit[2:0], digit[3]};
            end
        endcase
    end

    always @(*) begin
        case (temp_value)
            4'd0: next_display = `ZERO;
            4'd1: next_display = `ONE;
            4'd2: next_display = `TWO;
            4'd3: next_display = `THREE;
            4'd4: next_display = `FOUR;
            4'd5: next_display = `FIVE;
            4'd6: next_display = `SIX;
            4'd7: next_display = `SEVEN;
            4'd8: next_display = `EIGHT;
            4'd9: next_display = `NINE;
            4'd10: next_display = `NOTHING;
            default:next_display = `NOTHING;
        endcase
    end

    always @(*) begin
        _led = 0;
        /*
        if (map[19:0] > 0) _led[0] = 1'b1;
        if (map[39:20] > 0) _led[1] = 1'b1;
        if (map[59:40] > 0) _led[2] = 1'b1;
        if (map[79:60] > 0) _led[3] = 1'b1;
        if (map[99:80] > 0) _led[4] = 1'b1;
        if (map[119:100] > 0) _led[5] = 1'b1;
        if (map[139:120] > 0) _led[6] = 1'b1;
        if (map[159:140] > 0) _led[7] = 1'b1;
        if (map[179:160] > 0) _led[8] = 1'b1;
        if (map[199:180] > 0) _led[9] = 1'b1;
        */
        if (key_set[0] |key_set[1] |key_set[2] | key_set[3]) _led[8] = 1'b1;

        if(fail_1) begin
            _led[6:0] = 7'b1111111;
        end
        else if (fail_2) begin
            _led[15:9] = 7'b1111111;
        end
    end

    assign _digit = digit;
    assign _display = display;
endmodule