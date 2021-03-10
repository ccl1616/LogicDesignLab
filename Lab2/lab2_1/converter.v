// bcdtoex3 to led
module converter(a,b,c,d,w,x,y,z);
input a,b,c,d;
output w,x,y,z;

assign w = a | (b&c) | (b&d);
assign x = ( b&(~c)&(~d) ) | ( (~b)&(d|c) );
assign y = ( (~c)&(~d) ) | (c&d);
assign z = (~d);
endmodule