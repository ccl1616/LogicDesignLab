module top_freqdiv(fout, clk, rst_n);

output fout; //devided output
input clk;
input rst_n; //active low reset

freqdiv U0(.clk_out(fout), .clk(clk), .rst_n(rst_n) );

endmodule