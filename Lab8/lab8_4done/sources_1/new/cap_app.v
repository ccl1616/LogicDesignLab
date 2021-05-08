module cap_app(
    input clk,rst,
    input [8:0]last_change,
    input newkey,
    input [511:0]key_down,
    output [7:0]AS_letter,
    output caps_lock
);

wire [7:0]ascii;
last2ascii U_LAST2A(
    .clk(clk),  // clock input
    .rst(rst), 
    .last_change(last_change),
    .ascii(ascii)
);
FSM U_FSM(
    .clk(clk),  // clock input
    .rst(rst), 
    .last_change(last_change),
    .newkey(newkey),
    .caps_lock(caps_lock)
);
cap_or_low U_CORW(
    .caps_lock(caps_lock),
    .key_down(key_down),
    .ascii(ascii),
    .AS_letter(AS_letter)
);


endmodule