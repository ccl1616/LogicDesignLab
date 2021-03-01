module comparator(
    input [2:0] a,
    input [2:0] b,
    output [2:0] o,
    wire [2:0]x,
    wire flag
);
    assign x[0] = ~(a[0] ^ b[0]);
    assign x[1] = ~(a[1] ^ b[1]);
    assign x[2] = ~(a[2] ^ b[2]);
    assign flag = ( x[0]&x[1]&x[2] ) + ( x[2]&x[1]&a[0]&(~b[0]) ) + ( x[2]&a[1]&(~b[1]) ) + ( a[2]&(~b[2]) );
    assign o = flag? b:a;
endmodule