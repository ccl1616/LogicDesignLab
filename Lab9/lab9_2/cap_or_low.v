`timescale 1ns / 1ps

module cap_or_low(
    input caps_lock,
    input [511:0] key_down,
    input [7:0] ascii,
    output [7:0] AS_letter 
);

assign AS_letter = (caps_lock && ~(key_down[89] || key_down[18]) || (~caps_lock && (key_down[89] || key_down[18])) )?ascii : ( ascii!=8'd0 ?(ascii + 8'h20):8'd0 );

endmodule
