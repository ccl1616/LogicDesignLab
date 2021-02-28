module tb();
    reg a1,a0,b1,b0;
    wire c3,c2,c1,c0;

    lab1_2 t(.a1(a1),.a0(a0),.b1(b1),.b0(b0),.c3(c3),.c2(c2),c1(c1),c0(c0) );
    initial begin
        {A,B,C,D} = 4'b0;
        #10;
        repeat(16) begin
            #10;
            {a1,a0,b1,b0} = {a1,a0,b1,b0} + 1'b1;
        end
        $finish;
    end

endmodule