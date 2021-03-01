module FullAdder(x,y,z,s,c);
    input x,y,z;
    output s,c;
    assign s = ( (~x)&(~y)&z ) | ( (~x)&y&(~z) ) | ( x&(~y)&(~z) ) | ( x&y&z );
    assign c = ( x&y ) | ( x&z ) | ( y&z );
endmodule

module adder_subtractor (
    input signed [2:0] a, b,
    input m,
    output signed [2:0] s,
    output v,
    wire [2:0] temp,
    wire [3:0] carry
);
    assign temp[0] = b[0] ^ m;
    assign temp[1] = b[1] ^ m;
    assign temp[2] = b[2] ^ m;
    FullAdder f1(m,a[0],temp[0],s[0],carry[0]);
    FullAdder f2(carry[0],a[1],temp[1],s[1],carry[1]);   
    FullAdder f3(carry[1],a[2],temp[2],s[2],carry[2]);   
    assign v = carry[2] ^ carry[1];
endmodule