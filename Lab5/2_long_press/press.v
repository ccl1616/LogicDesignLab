`include "golbal.v"

module press(
    mode,
    short_press, 
    long_press,
    rst_n,
    clk
);
reg mode;
reg mode_delay;
reg [1:0]press_count_next;
reg [1:0]press_count;

// short press
assign short_press = (~mode)&mode_delay&( ~(press_count[1]&press_count[0]) );
always @(posedge clk or negedge rst_n) begin
    if(~rst_n)
        mode_delay <= `FALSE;
    else 
        mode_delay <= mode;
end

// long press
// combinational
assign long_press = (press_count == 2'b11);
always @* begin
    if(mode == `FALSE)
        press_count_next = 2'd0;
    else 
        press_count_next = press_count + 2'd1;
end

// sequential
always @(posedge clk or negedge rst_n) begin
    if(~rst_n)
        press_count <= 2'd0;
    else 
        press_count <= press_count_next;
end

endmodule