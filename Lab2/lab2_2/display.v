// 4bit binary to 7-seg

// define segment codes
`define SS_0 8'b00000011
`define SS_1 8'b10011111
`define SS_2 8'b00100101
`define SS_3 8'b00001101
`define SS_4 8'b10011001
`define SS_5 8'b01001001
`define SS_6 8'b01000001
`define SS_7 8'b00011111
`define SS_8 8'b00000001
`define SS_9 8'b00001001
`define SS_a 8'b00010001
`define SS_b 8'b11000001
`define SS_c 8'b01100011
`define SS_d 8'b10000101
`define SS_e 8'b01100001
`define SS_f 8'b01110001

module display(i, D, d);
input [3:0] i;
output [7:0] D;  
output [3:0] d; 
reg [7:0] D;

always @(*) begin 
    case (i)
        4'd0: D = `SS_0;
        4'd1: D = `SS_1;
        4'd2: D = `SS_2;
        4'd3: D = `SS_3;
        4'd4: D = `SS_4;
        4'd5: D = `SS_5;
        4'd6: D = `SS_6;
        4'd7: D = `SS_7;
        4'd8: D = `SS_8;
        4'd9: D = `SS_9;

        4'd10: D = `SS_a;
        4'd11: D = `SS_b;
        4'd12: D = `SS_c;
        4'd13: D = `SS_d;
        4'd14: D = `SS_e;
        4'd15: D = `SS_f;
        default: D = 8'b0000000;
    endcase
end

assign d = i;

endmodule