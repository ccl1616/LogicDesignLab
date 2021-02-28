module test_comparato;

reg [3:0] A, B;
wire [2:0] O;

comparator U0(
    .a2(A[2]),
    .a1(A[1]),
    .a0(A[0]),
    .b2(B[2]),
    .b1(B[1]),
    .b0(B[0]),
    .o2(O[2]),
    .o1(O[1]),
    .o0(O[0])
);

reg [2:0] golden;
initial begin
    for(A=0; A<8; A=A+1) begin
        for(B=0; B<8; B=B+1) begin
            golden = A<B? A:B;
            #10;
            if(golden!=O) begin
                $display("[ERROR] A:%d,B:%d    answer : %d your result : %d", A, B, golden, O);
                $finish;
            end
        end
    end
    
    $display("[OK] your function is correct");
end

endmodule