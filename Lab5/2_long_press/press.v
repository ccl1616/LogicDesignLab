`include "global.v"

module press(
    mode_in,
    short_press, 
    long_press,
    rst_n,
    clk
);
input mode_in;
input rst_n;
input clk;
output short_press;
output long_press;
reg pb_in;
reg mode_delay;
reg [1:0]press_count_next;
reg [1:0]press_count;

// short press
assign short_press = (~mode_in)&mode_delay&( ~(press_count[1]&press_count[0]) );
always @(posedge clk or negedge rst_n) begin
    if(~rst_n)
        mode_delay <= `FALSE;
    else 
        mode_delay <= mode_in;
end

// long press
// combinational
assign long_press = (press_count == 2'b11)&(mode_in==1'b1);
always @* begin
    if(mode_in == `FALSE)
        press_count_next = 2'd0;
    else 
        press_count_next = press_count + ( (press_count==2'd3)?2'd0:2'd1 );
end

// sequential
always @(posedge clk or negedge rst_n) begin
    if(~rst_n)
        press_count <= 2'd0;
    else 
        press_count <= press_count_next;
end

endmodule

