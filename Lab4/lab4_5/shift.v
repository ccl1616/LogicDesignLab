// 8 shift register cascade by DFF
// initial val = 1001_0110
`define BIT_WIDTH 8
module shift(
    out0,
    out1,
    out2,
    out3,
    clk,
    rst_n
);

output [`CNT_BIT_WIDTH-1 : 0]out0;
output [`CNT_BIT_WIDTH-1 : 0]out1;
output [`CNT_BIT_WIDTH-1 : 0]out2;
output [`CNT_BIT_WIDTH-1 : 0]out3;
input clk;
input rst_n;

reg [`BIT_WIDTH-1 : 0] q;
reg [`BIT_WIDTH-1 : 0] x;
reg [`BIT_WIDTH-1 : 0] y;

always @(posedge clk or negedge rst_n)
    if(~rst_n)
        begin
            q <= `BIT_WIDTH'b1001_0110;
            x <=
            y <= 
            {q[7],x[7],y[7]} <= 4'b0010; //n
            {q[6],x[6],y[6]} <= 4'b0011; //t
            {q[5],x[5],y[5]} <= 4'b0001; //H
            {q[4],x[4],y[4]} <= 4'b0100; //U

            {q[3],x[3],y[3]} <= 4'b0000; //E
            {q[2],x[2],y[2]} <= 4'b0000; //E
            {q[1],x[1],y[1]} <= 4'b0101; //C
            {q[0],x[0],y[0]} <= 4'b0110; //S
            
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
            q = {q[6:0],q[7]};
        end

endmodule