module tb_adder_subtractor;

reg signed [2:0] a, b;
reg m;
wire signed [2:0] s;
wire v;

adder_subtractor U0(
    .a(a), 
    .b(b), 
    .m(m),
    .s(s), 
    .v(v)
);

// integer i, j;

// initial begin
//    m = 0;
//    for(i=0; i<8; i=i+1) begin
//        for(j=0; j<8; j=j+1) begin
//            #10 a = i - 4; b = j - 4;
//        end
//    end
//    #10 m = 1;
//    for(i=0; i<8; i=i+1) begin
//        for(j=0; j<8; j=j+1) begin
//            #10 a = i - 4; b = j - 4;
//        end
//    end
//end

initial begin
    a = -4; b = -4; m = 0; 
    #10;
    $display("s = %d, v = %d", s, v);
    if(v != 1 || s != 0) begin
    $display("[ERROR], answer should be s = 0, v = 1");
    $finish;
    end
#10 a = -3; b = -1; m = 0;
    #10;
    $display("s = %d, v = %d", s, v);
    if(v != 0 || s != -4) begin
    $display("[ERROR], answer should be s = -4, v = 0");
    $finish;
    end
#10 a =  1; b = -2; m = 0;
    #10;
    $display("s = %d, v = %d", s, v);
    if(v != 0 || s != -1) begin
    $display("[ERROR], answer should be s = -1, v = 0");
    $finish;
    end   
#10 a = -4; b =  3; m = 1;
    #10;
    $display("s = %d, v = %d", s, v);
    if(v != 1 || s != 1) begin
    $display("[ERROR], answer should be s = 1, v = 1");
    $finish;
    end
#10 a =  0; b = -4; m = 1;
    #10;
    $display("s = %d, v = %d", s, v);
    if(v != 1 || s != -4) begin
    $display("[ERROR], answer should be s = -4, v = 1");
    $finish;
    end
$display("[PASS], you did it !!!!!! ^o^]");
end

endmodule
