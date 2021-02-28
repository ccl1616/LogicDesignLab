module HalfAdder(a,b,sum,carry);
    input a,b;
    output sum,carry;
    xor(sum,a,b);
    and(carry,a,b);
endmodule

module lab1_2(
    input a1,a0,b1,b0;
    output c3,c2,c1,c0;
    wire [2:0]temp;
    wire carry;
);
    assign c0 = a0 & b0;
    assign temp[0] = a1 & b0;
    assign temp[1] = a0 & b1;
    assign temp[2] = a1 & b1;
    HalfAdder h1(temp[0],temp[1],c1,carry);
    HalfAdder h2(temp[2],carry,c2,c3);
endmodule
