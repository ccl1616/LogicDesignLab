module bcd2ascii(
    input clk,
    input rst,
    input [3:0]bcd,
    output reg [7:0]ascii
);
always@(*)begin
    case(bcd)
        4'h0: ascii = 8'h30;
        4'h1: ascii = 8'h31;
        4'h2: ascii = 8'h32;
        4'h3: ascii = 8'h33;
        4'h4: ascii = 8'h34;
        4'h5: ascii = 8'h35;
        4'h6: ascii = 8'h36;
        4'h7: ascii = 8'h37;
        4'h8: ascii = 8'h38;
        4'h9: ascii = 8'h39;
        default: ascii = 8'h30;
    endcase
end
endmodule