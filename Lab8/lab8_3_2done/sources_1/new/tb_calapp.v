`define TRUE 1'b1
`define FALSE 1'b0

module tb_calapp();
reg clk,rst,newkey;
reg [7:0] ascii;
wire [3:0] show0,show1,show2,show3;
wire is_neg;
calculator_app U_TB(
    .clk(clk),
    .rst(rst),
    .ascii(ascii),
    .newkey(newkey),
    .show0(show0),
    .show1(show1),
    .show2(show2),
    .show3(show3),
    .is_neg(is_neg)
);
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin
    rst = `TRUE;
    newkey = `FALSE;
    ascii = 8'h00;
    repeat(4)@(posedge clk); 
    
    rst = `FALSE;
    newkey = `TRUE;
    ascii = 8'h39; // press 
    repeat(1)@(posedge clk); 
    newkey = `FALSE;
    repeat(2)@(posedge clk); 
/*
    newkey = `TRUE;
    ascii = 8'h39; // press 
    repeat(1)@(posedge clk); 
    newkey = `FALSE;
    repeat(2)@(posedge clk); */

    newkey = `TRUE;
    ascii = 8'h2A; // press  sign
    repeat(1)@(posedge clk); 
    newkey = `FALSE;
    repeat(2)@(posedge clk); 

    newkey = `TRUE;
    ascii = 8'h39; // press 
    repeat(1)@(posedge clk); 
    newkey = `FALSE;
    repeat(2)@(posedge clk); 

    newkey = `TRUE;
    ascii = 8'h30; // press 
    repeat(1)@(posedge clk); 
    newkey = `FALSE;
    repeat(2)@(posedge clk); 

    newkey = `TRUE;
    ascii = 8'hE0; // press Enter
    repeat(1)@(posedge clk); 
    newkey = `FALSE;
    repeat(2)@(posedge clk); 
end
endmodule