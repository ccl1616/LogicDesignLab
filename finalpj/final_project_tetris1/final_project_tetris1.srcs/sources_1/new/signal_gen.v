`include "global.vh"

module signal_gen(
    input clk,
    input rst,
    input rotate,
    input down,
    input right,
    input left,
    input stop,
    input start,
    input [31:0] currentRotate,
    input [31:0] currentPiece,
    input signed [31:0] currentX,
    input signed [31:0] currentY,
    input [199:0] map,
    input [199:0] pure_map,
    input speed,
    input he_fail,
//-----------for 2 player----------//
    input [31:0] hard,
//------ add by 1 2 3 4 .....

    output rotate_hold,
    output reg force_down,
    output _down,
    output _right,
    output _left,
    output [4:0] _state,
    output I_fail
);

    wire clk_fail;
    clock_divider #(.n(27)) fail_clk(
        .clk(clk),
        .clk_div(clk_fail)
    );

    wire fit;
    does_piece_fit _fail (
        .clk(clk),
        .rst(rst),
        .currentRotate(currentRotate),
        .currentPiece(currentPiece),
        .currentX(currentX),
        .currentY(currentY),
        .map(pure_map),
        .fit(fit)
    );
    assign I_fail = (fit == 1'b0 && pure_map != 200'b0) ? 1'b1 : 1'b0;

    signal_peek for_right (
        .clk(clk),
        .rst(rst),
        .signal(right),
        .peek(_right)
    );

    signal_peek for_left (
        .clk(clk),
        .rst(rst),
        .signal(left),
        .peek(_left)
    );
    signal_peek for_down (
        .clk(clk),
        .rst(rst),
        .signal(down),
        .peek(_down)
    );
    signal_peek for_rotate (
        .clk(clk),
        .rst(rst),
        .signal(rotate),
        .peek(rotate_hold)
    );

    reg [4:0] state;
    reg [4:0] next_state;

    assign _state = state;

    reg my_time;
    always @(*) begin
        if (state == `FAIL) my_time = clk_fail;
        else my_time = clk;
    end

    always @(posedge my_time, posedge rst) begin
        if (rst) state <= `INI;
        else if (he_fail) state <= `FAIL;
        else state <= next_state;
    end

    always @(*) begin
        case (state)
            `INI : begin
                if (start) next_state = `GAME;
                else next_state = `INI;
            end
            `GAME : begin
                if ((fit == 1'b0) && (pure_map != 200'b0)) next_state = `FAIL;
                else next_state = `GAME;
            end
            `FAIL : begin
                next_state = `INI;
            end
            default : next_state = `INI;
        endcase
    end

    reg [31:0] time_limit;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            time_limit <= `TIMELIMIT;
        end
        else begin 
            if (speed) begin
                if (time_limit + hard*8000000 != `TIMELIMIT_FAST) begin
                    time_limit <= `TIMELIMIT_FAST - hard*8000000;
                end 
                else time_limit <= time_limit;
            end
            else begin
                if (time_limit + hard*8000000 != `TIMELIMIT) begin
                    time_limit <= `TIMELIMIT - hard*8000000;
                end 
                else time_limit <= time_limit;
            end
        end
    end
    reg [31:0] time_counter;
    always @(posedge clk ,posedge rst) begin
        if (rst) time_counter <= 0;
        else if (stop) time_counter <= 0;
        else begin
            if (time_counter >= time_limit) 
                time_counter <= 0;
            else 
                time_counter <= time_counter + 1;
            
        end  
    end
    always @(*) begin
        if (time_counter >= time_limit) force_down = 1;
        else force_down = 0;
    end

endmodule 