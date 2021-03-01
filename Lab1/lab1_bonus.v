module comparator(
    input a0,a1,a2;
    input b0,b1,b2;
    output o0,o1,o2;
    wire [2:0]x,
    wire flag
);
    assign x[0] = ~(a0 ^ b0);
    assign x[1] = ~(a1 ^ b1);
    assign x[2] = ~(a2 ^ b2);
    // flag = 1 if A>=B
    assign flag = ( x0&x1&x2 ) + ( x2&x1&a0&(~b0) ) + ( x2&a1&(~b1) ) + ( a2&(~b2) );
    assign o0 = flag? b0:a0;
    assign o1 = flag? b1:a1;
    assign o2 = flag? b2:a2;
endmodule