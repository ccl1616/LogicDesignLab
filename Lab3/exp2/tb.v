
`define FREQ_BIT 27
`define CYC_C 50000000


module tb;

// wire [`FREQ_BIT-1 : 0] q;
wire ans;
reg clk;
reg rst_n;

freqdiv_50 U0(
    .ans(ans), 
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
    #(10*`CYC_C);
end

endmodule