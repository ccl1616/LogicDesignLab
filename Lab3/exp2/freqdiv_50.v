// build a counter for 50M
// and generate 1Hz signal by 100M/(2*50M) = 1Hz

// divide 50M

`define FREQ_BIT 26 
`define DIV 50000000 


module freqdiv_50(
    ans,
    clk,
    rst_n
);

// output [`FREQ_BIT-1 : 0] q;
input clk;
input rst_n;
output ans;
wire t_tmp;

reg [`FREQ_BIT-1 : 0] q;
reg [`FREQ_BIT-1 : 0] cnt_tmp; //input to DFF
reg t_tmp;
reg ans;
reg cmp;

// div 50M
// combinational
always@*
    cnt_tmp = q + 1'b1;

// sequential
always @(posedge clk or negedge rst_n)
    if(~rst_n) q <= `FREQ_BIT'd0; //to this
    else begin
        q <= (q == `FREQ_BIT'd`DIV-1)? `FREQ_BIT'd0:cnt_tmp;
        cmp = (q == `FREQ_BIT'd`DIV-1)? 1:0;
    end
// tff
xor(t_tmp,cmp,ans);

always @(posedge clk or negedge rst_n)
    if(~rst_n) ans <= 0;
    else ans <= t_tmp;
endmodule