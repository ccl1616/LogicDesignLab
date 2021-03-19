`define FREQ_BIT 3
module tb;

wire [`FREQ_BIT-1 : 0] q;
reg clk;
reg rst_n;

freqdiv_50 U0(
    .q(q), 
    .clk(clk), 
    .rst_n(rst_n)
);

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin
    rst_n = 1'b0;
    #5
    rst_n = 1'b1;
end

endmodule