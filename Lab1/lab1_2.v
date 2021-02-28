module HalfAdder(a,b,sum,carry);
    input a,b;
    output sum,carry;
    xor(sum,a,b);
    and(carry,a,b);
endmodule

module lab1_2(
    input [1:0] a,b;
    output [3:0] c;
    wire [2:0]temp;
    wire carry;
);
    assign c[0] = a[0] & b[0];
    assign temp[0] = a[1] & b[0];
    assign temp[1] = a[0] & b[1];
    assign temp[2] = a[1] & b[1];
    HalfAdder h1(temp[0],temp[1],c[1],carry);
    HalfAdder h2(temp[2],carry,c[2],c[3]);
endmodule
