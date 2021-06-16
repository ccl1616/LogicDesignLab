`include "global.vh"

module random (
    input clk,
    input rst,
    // need in 0 ~ 6
    output [31:0] rand
);
	reg [9:0] counter = 0;
	always @(posedge clk or posedge rst) begin
		if (rst) begin
			counter <= 0;
		end
		else begin
			if (counter == 6) counter <= 0;
			else counter <= counter + 1;	
		end
	end
	assign rand = {21'b0, counter};
endmodule 