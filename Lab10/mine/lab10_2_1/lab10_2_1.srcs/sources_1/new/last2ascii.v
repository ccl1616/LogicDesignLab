module last2ascii(
    input clk,
    input rst,
    input [8:0]last_change,
    output reg [7:0]ascii
);
always@(*)begin
    case(last_change)
        9'h70: ascii = 8'h30;
        9'h69: ascii = 8'h31;
        9'h72: ascii = 8'h32;
        9'h7A: ascii = 8'h33;
        9'h6B: ascii = 8'h34;
        9'h73: ascii = 8'h35;
        9'h74: ascii = 8'h36;
        9'h6C: ascii = 8'h37;
        9'h75: ascii = 8'h38;
        9'h7D: ascii = 8'h39;
        9'h71: ascii = 8'h2E; //.
        9'h7C: ascii = 8'h2A; //*
        9'h79: ascii = 8'h2B; //+
        9'h7B: ascii = 8'h2D; //- 
        9'h5A: ascii = 8'hE0; //enter
        default: ascii = 8'h30;
    endcase
end
endmodule