module tb();

    reg A,B,C,D;
    wire W,X,Y,Z;

    lab1_1 t(.a(A),.b(B),.c(C),.d(D),.w(W),.x(X),y(Y),z(Z) );

    assign W = A | (B&C) | (B&D);
    assign X = ( B&(~C)&(~D) ) | ( (~B)&(D|C) );
    assign Y = ( (~C)&(~D) ) | (C&D);
    assign Z = (~D);

    initial begin
        {A,B,C,D} = 4'b0;
        #10;
        repeat(10) begin
            #10;
            $display("%b%b%b%b , %b%b%b%b\n", A,B,C,D,W,X,Y,Z);
            {A,B,C,D} = {A,B,C,D} + 1'b1;
        end
        $finish;
    end

endmodule