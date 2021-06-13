`include "global.vh"

module for_score (
	input clk,
	input rst,
	input [199:0] map,
	output [31:0] delta_score
);

	reg [31:0] _score;
	reg [31:0] next_score;

	assign delta_score = _score;

	always @(posedge clk or posedge rst) begin
		if (rst) begin
			_score <= 0;			
		end
		else begin
			_score <= ((map[0]&map[0+20]&map[0+40]&map[0+60]&
                    map[0+80]&map[0+100]&map[0+120]&map[0+140]&
                    map[0+160]&map[0+180]) ? 1 : 0) +
					    ((map[1]&map[1+20]&map[1+40]&map[1+60]&
                    map[1+80]&map[1+100]&map[1+120]&map[1+140]&
                    map[1+160]&map[1+180]) ? 1 : 0) + 
						((map[3]&map[3+20]&map[3+40]&map[3+60]&
                    map[3+80]&map[3+100]&map[3+120]&map[3+140]&
                    map[3+160]&map[3+180]) ? 1 : 0) + 
						((map[4]&map[4+20]&map[4+40]&map[4+60]&
                    map[4+80]&map[4+100]&map[4+120]&map[4+140]&
                    map[4+160]&map[4+180]) ? 1 : 0) + 
						((map[5]&map[5+20]&map[5+40]&map[5+60]&
                    map[5+80]&map[5+100]&map[5+120]&map[5+140]&
                    map[5+160]&map[5+180]) ? 1 : 0) + 
						((map[6]&map[6+20]&map[6+40]&map[6+60]&
                    map[6+80]&map[6+100]&map[6+120]&map[6+140]&
                    map[6+160]&map[6+180]) ? 1 : 0) + 
						((map[7]&map[7+20]&map[7+40]&map[7+60]&
                    map[7+80]&map[7+100]&map[7+120]&map[7+140]&
                    map[7+160]&map[7+180]) ? 1 : 0) +
						((map[8]&map[8+20]&map[8+40]&map[8+60]&
                    map[8+80]&map[8+100]&map[8+120]&map[8+140]&
                    map[8+160]&map[8+180]) ? 1 : 0) +
						((map[9]&map[9+20]&map[9+40]&map[9+60]&
                    map[9+80]&map[9+100]&map[9+120]&map[9+140]&
                    map[9+160]&map[9+180]) ? 1 : 0) +
						((map[10]&map[10+20]&map[10+40]&map[10+60]&
                    map[10+80]&map[10+100]&map[10+120]&map[10+140]&
                    map[10+160]&map[10+180]) ? 1 : 0) +
						((map[11]&map[11+20]&map[11+40]&map[11+60]&
                    map[11+80]&map[11+100]&map[11+120]&map[11+140]&
                    map[11+160]&map[11+180]) ? 1 : 0) +
						((map[12]&map[12+20]&map[12+40]&map[12+60]&
                    map[12+80]&map[12+100]&map[12+120]&map[12+140]&
                    map[12+160]&map[12+180]) ? 1 : 0) +
						((map[13]&map[13+20]&map[13+40]&map[13+60]&
                    map[13+80]&map[13+100]&map[13+120]&map[13+140]&
                    map[13+160]&map[13+180]) ? 1 : 0) +
						((map[14]&map[14+20]&map[14+40]&map[14+60]&
                    map[14+80]&map[14+100]&map[14+120]&map[14+140]&
                    map[14+160]&map[14+180]) ? 1 : 0) +
						((map[15]&map[15+20]&map[15+40]&map[15+60]&
                    map[15+80]&map[15+100]&map[15+120]&map[15+140]&
                    map[15+160]&map[15+180]) ? 1 : 0) +
						((map[16]&map[16+20]&map[16+40]&map[16+60]&
                    map[16+80]&map[16+100]&map[16+120]&map[16+140]&
                    map[16+160]&map[16+180]) ? 1 : 0) +
						((map[17]&map[17+20]&map[17+40]&map[17+60]&
                    map[17+80]&map[17+100]&map[17+120]&map[17+140]&
                    map[17+160]&map[17+180]) ? 1 : 0) +
						((map[18]&map[18+20]&map[18+40]&map[18+60]&
                    map[18+80]&map[18+100]&map[18+120]&map[18+140]&
                    map[18+160]&map[18+180]) ? 1 : 0) +
						((map[19]&map[19+20]&map[19+40]&map[19+60]&
                    map[19+80]&map[19+100]&map[19+120]&map[19+140]&
                    map[19+160]&map[19+180]) ? 1 : 0) ;
		end
	end
endmodule 