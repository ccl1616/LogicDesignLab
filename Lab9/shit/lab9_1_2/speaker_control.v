`timescale 1ns / 1ps

module speaker_control(
    input clk ,rst,
    input [15:0] audio_in_left,
    input [15:0] audio_in_right,
    output audio_mclk,
    output audio_lrclk,
    output audio_sclk,
    output reg audio_sdin
    
    );
    
reg [26:0] reference, reference_tmp;
reg [4:0] serial_ref;
wire ref_clk;

assign audio_mclk = reference[1];
assign audio_sclk = reference[3];
assign audio_lrclk = reference[8];
assign ref_clk = reference[2];

always@(*)
  if(reference == 27'd50000000)
    reference_tmp = 27'd0;
  else
    reference_tmp = reference + 1'b1;
    
always@(posedge clk or posedge rst)
  if(rst)
    reference <= 27'b0;
  else
    reference <= reference_tmp;
  
    
always@(posedge ref_clk or posedge rst)
	if(rst)
    serial_ref  <= 5'd0;
	else
	  serial_ref <= serial_ref + 1'b1;
	 
always@(*)
  begin
    case(serial_ref)
      5'd0 : audio_sdin = audio_in_right[15];
      5'd1 : audio_sdin = audio_in_right[14];
      5'd2 : audio_sdin = audio_in_right[13];
      5'd3 : audio_sdin = audio_in_right[12];
      5'd4 : audio_sdin = audio_in_right[11];
      5'd5 : audio_sdin = audio_in_right[10];
      5'd6 : audio_sdin = audio_in_right[9];
      5'd7 : audio_sdin = audio_in_right[8];
      5'd8 : audio_sdin = audio_in_right[7];
      5'd9 : audio_sdin = audio_in_right[6];
      5'd10 : audio_sdin = audio_in_right[5];
      5'd11 : audio_sdin = audio_in_right[4];
      5'd12 : audio_sdin = audio_in_right[3];
      5'd13 : audio_sdin = audio_in_right[2];
      5'd14 : audio_sdin = audio_in_right[1];
      5'd15 : audio_sdin = audio_in_right[0];
      5'd16 : audio_sdin = audio_in_left[15];
      5'd17 : audio_sdin = audio_in_left[14];
      5'd18 : audio_sdin = audio_in_left[13];
      5'd19 : audio_sdin = audio_in_left[12];
      5'd20 : audio_sdin = audio_in_left[11];
      5'd21 : audio_sdin = audio_in_left[10];
      5'd22 : audio_sdin = audio_in_left[9];
      5'd23 : audio_sdin = audio_in_left[8];
      5'd24 : audio_sdin = audio_in_left[7];
      5'd25 : audio_sdin = audio_in_left[6];
      5'd26 : audio_sdin = audio_in_left[5];
      5'd27 : audio_sdin = audio_in_left[4];
      5'd28 : audio_sdin = audio_in_left[3];
      5'd29 : audio_sdin = audio_in_left[2];
      5'd30 : audio_sdin = audio_in_left[1];
      5'd31 : audio_sdin = audio_in_left[0];
      default : audio_sdin = 1'b0;
    endcase
  end

endmodule