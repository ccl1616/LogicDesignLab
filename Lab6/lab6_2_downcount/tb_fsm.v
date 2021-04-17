module tb_fsm();

fsm U_TB(
    .pb_ps(pb_ps),
    .pb_start(pb_start),
    .switch(switch),
    .clk(clk),
    .rst_n(rst_n),
    .all_zero(all_zero),
    .count_enable(count_enable),
    .load_enable(load_enable),
    .state(state)
);
reg pb_ps;
reg pb_start;
reg switch;
reg clk;
reg rst_n;
reg all_zero;
wire count_enable;
wire load_enable;
wire [2:0]state;

`define CYC 10
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin
    repeat(2)@(posedge clk);
        rst_n = 1'b0;
        pb_ps = 1'b0;
        pb_start = 1'b0;
        switch = 1'b0;
        all_zero = 1'b0;
    repeat(1)@(posedge clk);
        pb_start = 1'b1;
    repeat(2)@(posedge clk);
        pb_start = 1'b0;

    repeat(1)@(posedge clk);
        pb_ps = 1'b1;
    repeat(2)@(posedge clk);
        pb_ps = 1'b0;

    repeat(1)@(posedge clk);
        pb_ps = 1'b1;
    repeat(2)@(posedge clk);
        pb_ps = 1'b0;

    repeat(1)@(posedge clk);
        pb_ps = 1'b1;
    repeat(2)@(posedge clk);
        pb_ps = 1'b0;
    repeat(1)@(posedge clk);
        pb_start = 1'b1;
    pb_start = 1'b0;
end
endmodule