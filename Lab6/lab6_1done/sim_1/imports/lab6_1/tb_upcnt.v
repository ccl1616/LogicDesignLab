
module tb_upcnt();
// output
wire [3:0] digit0;
wire [3:0] digit1;
wire [3:0] digit2;
wire [3:0] digit3;

// input
reg nowlap;
reg en;
reg rst;
reg clk;
reg rst_n;

upcounter_4d U_TB(
    .nowlap(nowlap), 
    .en(en), // count enable input
    .rst(rst), // fsm pb rst signal
    .digit0(digit0),  // right most digit
    .digit1(digit1), 
    .digit2(digit2),
    .digit3(digit3),
    .clk(clk),  // global clock
    .rst_n(rst_n)  // low active reset
);
`define CYC 10
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin
    rst_n = 1'b0;
    nowlap = 1'b0;
    en = 1'b0;
    rst = 1'b0;
    # (`CYC*2);

    rst_n = 1'b1;
    # (`CYC*2);
    en = 1'b1;
    # (`CYC*20);
    en = 1'b0;
    # (`CYC*4);
    en = 1'b1;
    # (`CYC*4);
    
    // repeat(10)@(posedge clk);
    nowlap = 1'b1;
    # (`CYC*10);
    repeat(10)@(posedge clk);
    nowlap = 1'b0;
end

endmodule