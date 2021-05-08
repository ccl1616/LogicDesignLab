`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/27/2016 04:39:01 PM
// Design Name: 
// Module Name: bin2ascii
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module bin2ascii #(
    parameter NBYTES=3  // convert 3 byte of data to ASCII code in buffers O
) (
    input  [NBYTES*8-1:0] I,    
    output [NBYTES*16-1:0] O
//    output reg [NBYTES*16-1:0] O=0
);
    genvar i;
      generate for (i=0; i<NBYTES*2; i=i+1) begin
        assign O[8*i+7:8*i] = (I[4*i+3:4*i] >= 4'h0 && I[4*i+3:4*i] <= 4'h9)? ( 8'd48 + I[4*i+3:4*i] ) : ( 8'd55 + I[4*i+3:4*i] );
      end
    endgenerate

//    genvar i;
//      generate for (i=0; i<NBYTES*2; i=i+1) begin
//        always@(I)
//          if (I[4*i+3:4*i] >= 4'h0 && I[4*i+3:4*i] <= 4'h9)
//              O[8*i+7:8*i] = 8'd48 + I[4*i+3:4*i];    // Maping number 0~9;  ASCII code 'd48~'d57
//          else
//              O[8*i+7:8*i] = 8'd55 + I[4*i+3:4*i];    // Mapping Asci code A-F  10-15 mapping to 65-70
//      end
//    endgenerate

endmodule
