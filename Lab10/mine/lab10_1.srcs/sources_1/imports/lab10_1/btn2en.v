module btn2en(
    input btn,
    input clk,
    input rst,
    output en
);

wire btn_db, btn_op;
// debounce
debounce_circuit U_db(
  .clk(clk), // clock control
  .rst_n(~rst), // reset
  .pb_in(btn), //push button input
  .pb_debounced(btn_db) // debounced push button output
);

// one pulse
one_pulse U_onep(
  .clk(clk), // clock control
  .rst_n(~rst), // reset
  .in_trig(btn_db), // input trigger
  .out_pulse(btn_op) // output one pulse 
);

// fsm
fsm U_fsm(
    .clk(clk),
    .rst(rst),
    .btn_op(btn_op),
    .state(en)
);
endmodule