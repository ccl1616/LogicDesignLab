module as2num(
    input [7:0]AS_letter,
    output reg [3:0]num
);
always@(*)
  case(AS_letter)
    8'd99 : num = 4'd0;
    8'd100 : num = 4'd1;
    8'd101 : num = 4'd2;
    8'd102 : num = 4'd3;
    8'd103 : num = 4'd4;
    8'd97 : num = 4'd5;
    8'd98 : num = 4'd6;
    8'd67 : num = 4'd7;
    8'd68 : num = 4'd8;
    8'd69 : num = 4'd9;
    8'd70 : num = 4'd10;
    8'd71 : num = 4'd11;
    8'd65 : num = 4'd12;
    8'd66 : num = 4'd13;
    default : num = 4'd0;
  endcase
endmodule