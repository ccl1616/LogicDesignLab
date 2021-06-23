`include "global.vh"

module signal_peek (
	input clk,
	input rst,
	input signal,
	output reg peek
);
	wire peek_sudden;
	OnePulse fuck_you (
		.clock(clk),
		.signal(signal),
		.signal_single_pulse(peek_sudden)
	);	
	reg [31:0] counter;
	always @(posedge clk or posedge rst) begin
		if (rst) begin
			peek <= 0;
			counter <= 0;
		end
		else if (signal == 1'b0) begin
			peek <= 0;
			counter <= 0;
		end
		else begin
			if (peek_sudden == 1'b1) begin
				peek <= 1;	
				counter <= 0;
			end
			else if (counter < `SIGNAL_TIME) begin
				peek <= 0;	
				counter <= counter + 1;
			end
			else begin
				peek <= 1;
				counter <= 0;
			end
		end
	end

endmodule 