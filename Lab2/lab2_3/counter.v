// Bulls and cows - guessing numbers
// counter for bullcowgame
module counter(bin,led);
// 8 for guessed-number, 8 for guessing
// led[3:2] is for bulls(A), led[1:0] is for cows(B)
input [15:0] bin;
output [3:0] led;
reg [3:0] led;

always@(*) begin
    led[3:2] = (bin[15:12] == bin[7:4]) + (bin[11:8] == bin[3:0]);
    led[1:0] = (bin[15:12] == bin[3:0]) + (bin[11:8] == bin[7:4]);
end

endmodule