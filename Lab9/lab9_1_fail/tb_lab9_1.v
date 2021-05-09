`timescale 1ns / 1ps

module tb_lab9_1();
reg clk,rst;
wire audio_mclk; // master clock
wire audio_lrck; // left-right clock
wire audio_sck; // serial clock
wire audio_sdin; // serial audio data input
wire [7:0]segs;
wire [3:0]ssd_ctl;

top U_Tone(
    .clk(clk),
    .rst_n(rst_n),
    .audio_mclk(audio_mclk), // master clock
    .audio_lrck(audio_lrck), // left-right clock
    .audio_sck(audio_sck), // serial clock
    .audio_sdin(audio_sdin) // serial audio data input
    .segs(segs), // 7 segment display control
    .ssd_ctl(ssd_ctl) // scan control for 7-segment display
);
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin
    rst = 1'b1;
    repeat(2)@(posedge clk);
    rst = 1'b0;
end
endmodule
