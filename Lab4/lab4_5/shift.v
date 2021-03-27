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
wire [`CNT_BIT_WIDTH-1 : 0]out0;
wire [`CNT_BIT_WIDTH-1 : 0]out1;
wire [`CNT_BIT_WIDTH-1 : 0]out2;
wire [`CNT_BIT_WIDTH-1 : 0]out3;

always @(posedge clk or negedge rst_n) begin
    if(~rst_n)
        begin
            // do reset
            {q[7],x[7],y[7]} <= 3'b010; //n
            {q[6],x[6],y[6]} <= 3'b011; //t
            {q[5],x[5],y[5]} <= 3'b001; //H
            {q[4],x[4],y[4]} <= 3'b100; //U

            {q[3],x[3],y[3]} <= 3'b000; //E
            {q[2],x[2],y[2]} <= 3'b000; //E
            {q[1],x[1],y[1]} <= 3'b101; //C
            {q[0],x[0],y[0]} <= 3'b110; //S
            
        end
    else
        begin
            // do shift
            q = {q[6:0],q[7]};
            x = {x[6:0],x[7]};
            y = {y[6:0],y[7]};
        end
end

assign out3 = {1'b0,q[7],x[7],y[7]};
assign out2 = {1'b0,q[6],x[6],y[6]};
assign out1 = {1'b0,q[5],x[5],y[5]};
assign out0 = {1'b0,q[4],x[4],y[4]};

endmodule