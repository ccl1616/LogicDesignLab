module lab1_1 (
    input a,b,c,d,
    output w,x,y,z
);
    assign w = a | (b&c) | (b&d);
    assign x = ( b&(~c)&(~d) ) | ( (~b)&(d|c) );
    assign y = ( (~c)&(~d) ) | (c&d);
    assign z = (~d);
endmodule