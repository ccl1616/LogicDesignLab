// top module
module bullcow(sw,led);
input [15:0] sw;
output [3:0] led;

counter U0(.bin(sw),.led(led));

endmodule