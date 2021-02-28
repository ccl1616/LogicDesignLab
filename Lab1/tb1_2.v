module tb;

reg [1:0] a,b;
wire [3:0] c;

lab1_2 t(
    .a(a), 
    .b(b), 
    .c(c)
);
initial begin
    {a,b} = 4'b0;
    #10;
    repeat(16) begin
        #10;
        {a,b} = {a,b} + 1'b1;
    end
    $finish;
end

endmodule