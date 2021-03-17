// 8 shift register cascade by DFF
// initial val = 1001_0110

`define BIT_WIDTH 8
module shift(
    q,
    clk,
    rst_n
);

output [`BIT_WIDTH-1 : 0] q;
input clk;
input rst_n;
reg [`BIT_WIDTH-1 : 0] q;

always @(posedge clk or negedge rst_n)
    if(~rst_n)
        begin
            q <= `BIT_WIDTH'b1001_0110;
        end
    else
        begin
            q[0] <= q[7];
            q[1] <= q[0];
            q[2] <= q[1];
            q[3] <= q[2];
            q[4] <= q[3];
            q[5] <= q[4];
            q[6] <= q[5];
            q[7] <= q[6];
        end

endmodule