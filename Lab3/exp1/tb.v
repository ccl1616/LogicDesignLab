`define FREQ_BIT 27
module tb;

wire clk_out; //devided output
reg clk;
reg rst_n; //active low reset
freqdiv U0(
    .clk_out(clk_out),
    .clk(clk),
    .rst_n(rst_n)
);

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin
    rst_n = 1'b0;
    #5;
    rst_n = 1'b1;
end

endmodule