module tb();

reg a,b,c,d;
wire w,x,y,z;

lab1_1 t(
    .a(a),
    .b(b),
    .c(c),
    .d(d),
    .w(w),
    .x(x),
    .y(y),
    .z(z) 
);

assign w = a | (b&c) | (b&d);
assign x = ( b&(~c)&(~d) ) | ( (~b)&(d|c) );
assign y = ( (~c)&(~d) ) | (c&d);
assign z = (~d);

initial begin
    {a,b,c,d} = 4'b0;
    #10;
    repeat(10) begin
        #10;
        $display("%b%b%b%b , %b%b%b%b\n",a,b,c,d,w,x,y,z);
        {a,b,c,d} = {a,b,c,d} + 1'b1;
    end
    $finish;
end

endmodule