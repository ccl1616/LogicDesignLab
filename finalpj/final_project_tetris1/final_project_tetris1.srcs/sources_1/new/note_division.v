`timescale 1ns / 1ps
`include "global.v"
module note_division(
    input clk_1Hz, rst,
    output reg [21:0] note_division
);

reg [6:0] reference; // 7 bits

always@(posedge clk_1Hz or posedge rst)
  if(rst)
    reference <= 7'd0;
  else if(reference == 7'd59)
    reference <= 7'd0;
  else
    reference <= reference + 1'b1;

always@(*)
  case(reference)
    7'd0 : note_division = `HIGH_MI;
    7'd1 : note_division = `HIGH_MI;
    7'd2 : note_division = `MID_SI;
    7'd3 : note_division = `HIGH_DO;
    7'd4 : note_division = `HIGH_RE;
    7'd5 : note_division = `HIGH_MI;
    7'd6 : note_division = `HIGH_DO;
    7'd7 : note_division = `MID_SI;
    7'd8 : note_division = `MID_LA;
    7'd9 : note_division = `MID_LA;
    7'd10 : note_division = `MID_LA;
    7'd11 : note_division = `HIGH_DO;
    7'd12 : note_division = `HIGH_MI;
    7'd13 : note_division = `SILENT;
    
    7'd14 : note_division = `HIGH_RE;
    7'd15 : note_division = `HIGH_DO;
    7'd16 : note_division = `MID_SI;
    7'd17 : note_division = `MID_SI;
    7'd18 : note_division = `MID_SI;
    7'd19 : note_division = `HIGH_DO;
    7'd20 : note_division = `HIGH_RE;
    7'd21 : note_division = `HIGH_MI;
    7'd22 : note_division = `HIGH_DO;
    7'd23 : note_division = `HIGH_DO;
    7'd24 : note_division = `MID_LA;
    7'd25 : note_division = `MID_LA;
    7'd26 : note_division = `MID_LA;
    7'd27 : note_division = `MID_LA;
    7'd28 : note_division = `SILENT;
    7'd29 : note_division = `SILENT;
    
    7'd30 : note_division = `HIGH_RE;
    7'd31 : note_division = `HIGH_RE;
    7'd32 : note_division = `HIGH_FA;
    7'd33 : note_division = `HIGH_LA;
    7'd34 : note_division = `HIGH_LA;
    7'd35 : note_division = `HIGH_SO;
    7'd36 : note_division = `HIGH_FA;
    7'd37 : note_division = `HIGH_MI;
    7'd38 : note_division = `HIGH_MI;
    7'd39 : note_division = `HIGH_DO;
    7'd40 : note_division = `HIGH_MI;
    7'd41 : note_division = `HIGH_MI;
    
    7'd42 : note_division = `HIGH_RE;
    7'd43 : note_division = `HIGH_DO;
    7'd44 : note_division = `MID_SI;
    7'd45 : note_division = `MID_SI;
    7'd46 : note_division = `MID_SI;
    7'd47 : note_division = `HIGH_DO;
    7'd48 : note_division = `HIGH_RE;
    7'd49 : note_division = `HIGH_MI;
    7'd50 : note_division = `HIGH_DO;
    7'd51 : note_division = `HIGH_DO;
    7'd52 : note_division = `MID_LA;
    7'd53 : note_division = `MID_LA;
    7'd54 : note_division = `MID_LA;
    7'd55 : note_division = `MID_LA;
    
    default : note_division = `SILENT;
  endcase

endmodule