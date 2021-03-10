// top module
module bcd_ex3(a,b,c,d,w,x,y,z);
input a,b,c,d;
output w,x,y,z;

converter U0(.a(a),.b(b),.c(c),.d(d),.w(w),.x(x),.y(y),.z(z));
endmodule