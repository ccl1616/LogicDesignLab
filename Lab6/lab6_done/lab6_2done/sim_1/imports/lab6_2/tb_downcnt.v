module tb_downcnt();

reg [3:0] loadval0;
reg [3:0] loadval1;
reg [3:0] loadval2;
reg [3:0] loadval3;
reg clk;  // global clock
reg rst_n;  // low active reset
reg load_enable;
reg en; // enable/disable for the stopwatch

wire [3:0] digit0; // 2nd digit of the down counter
wire [3:0] digit1;  // 1st digit of the down counter
wire [3:0] digit2;
wire [3:0] digit3;

downcounter_4d U_DC(
  .loadval0(loadval0),
  .loadval1(loadval1),
  .loadval2(loadval2),
  .loadval3(loadval3),
  .digit0(digit0),  // 2nd digit of the down counter
  .digit1(digit1),  // 1st digit of the down counter
  .digit2(digit2),
  .digit3(digit3),
  .clk(clk),  // global clock
  .rst_n(rst_n),  // low active reset
  .load_enable(load_enable),
  .en(en) // enable/disable for the stopwatch
);

`define CYC 10
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin
    rst_n = 1'b0;
    {loadval3,loadval2,loadval1,loadval0} = {4'd3,4'd2,4'd1,4'd0};
    load_enable = 1'b0;
    en = 1'b0;
    repeat(1)@(posedge clk);
    rst_n = 1'b1;
    load_enable = 1'b1;
    repeat(1)@(posedge clk);
    en = 1'b1;
    load_enable = 1'b0;
    repeat(20)@(posedge clk);
    en = 1'b0;
    repeat(1)@(posedge clk);
    load_enable = 1'b1;
    repeat(1)@(posedge clk);
    load_enable = 1'b0;
end
endmodule