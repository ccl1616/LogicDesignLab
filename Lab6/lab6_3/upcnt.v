`include "global.v"
// one digit counter 0~9, with carry_in and carry_out
module upcnt(
    q, 
    carry_in,
    carry_out, 
    init_val,
    limit,
    clk,
    rst_n // low active reset
);
output [3:0]q;
output carry_out;
input carry_in;
input [3:0]limit;
input clk;
input rst_n;
input [3:0]init_val; // for setting time and count up, temp no use

reg [3:0]q;
reg [3:0]q_tmp;
reg carry_out;

// combinational
always@* begin
    if( (carry_in == 1'b1) & (q==limit) ) 
    begin
        q_tmp = 3'd0;
        carry_out = 1'b1;
    end
    else if( (carry_in == 1'b1) )
    begin
        q_tmp = q+1;
        carry_out = 1'b0;
    end
    else 
    begin 
        q_tmp = q;
        carry_out = 1'b0;
    end
end

// sequential DFF
always@(posedge clk or negedge rst_n)
    if(~rst_n) q <= 0;
    else q <= q_tmp;

endmodule