`timescale 1ns / 1ps

module tb_tone();
reg clk,rst_n,pb_l,pb_c,pb_r,pb_u,pb_d;
wire audio_mclk; // master clock
wire audio_lrck; // left-right clock
wire audio_sck; // serial clock
wire audio_sdin; // serial audio data input
top U_Tone(
    .clk(clk),
    .rst_n(rst_n),
    .pb_l(pb_l),
    .pb_c(pb_c),
    .pb_r(pb_r),
    .pb_u(pb_u),
    .pb_d(pb_d),
    .audio_mclk(audio_mclk), // master clock
    .audio_lrck(audio_lrck), // left-right clock
    .audio_sck(audio_sck), // serial clock
    .audio_sdin(audio_sdin) // serial audio data input
);
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin
    rst_n = 1'b0;
    pb_l = 1'b0;
    pb_c = 1'b0;
    pb_r = 1'b0;
    pb_u = 1'b0;
    pb_d = 1'b0;
    repeat(4)@(posedge clk);
    rst_n = 1'b1;
    pb_l = 1'b1;
    pb_u = 1'b1;
    repeat(10)@(posedge clk);
    pb_u = 1'b0;
    repeat(10)@(posedge clk);
    pb_u = 1'b1;
    repeat(10)@(posedge clk);
    pb_u = 1'b0;
end
endmodule
