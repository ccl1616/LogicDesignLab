// top module
// ssd_ctl for four of the 7seg 
module bin_7(bin,seg,led,ssd_ctl);
input [3:0] bin;
output [7:0] seg;
output [3:0] led;
output [3:0] ssd_ctl;

display U0(.i(bin),.D(seg),.d(led));
assign ssd_ctl = 4'b0000;

endmodule