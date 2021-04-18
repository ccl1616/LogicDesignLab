module interface(
    input clk, //clk_100
    input rst_n,
    input switch,
    input pbsec,
    input pbmin,
    input pbpause,
    input pbstart,
    output switch_o,
    output pbsec_o,
    output pbmin_o,
    output pbpause_o,
    output pbstart_o
);

debounce_circuit U_DB_DIP(
  .clk(clk), // clock control
  .rst_n(rst_n), // reset
  .pb_in(switch), //push button input
  .pb_debounced(switch_o) // debounced push button output
);
debounce_circuit U_PB_SEC(
  .clk(clk), // clock control
  .rst_n(rst_n), // reset
  .pb_in(pbsec), //push button input
  .pb_debounced(pbsec_o) // debounced push button output
);
debounce_circuit U_PB_MIN(
  .clk(clk), // clock control
  .rst_n(rst_n), // reset
  .pb_in(pbmin), //push button input
  .pb_debounced(pbmin_o) // debounced push button output
);

// need onepulse
wire pause_db,start_db;
debounce_circuit U_PB_PAUSE(
  .clk(clk), // clock control
  .rst_n(rst_n), // reset
  .pb_in(pbpause), //push button input
  .pb_debounced(pause_db) // debounced push button output
);
debounce_circuit U_PB_START(
  .clk(clk), // clock control
  .rst_n(rst_n), // reset
  .pb_in(pbstart), //push button input
  .pb_debounced(start_db) // debounced push button output
);
one_pulse U_OP_PAUSE(
  .clk(clk_100),  // clock input
  .rst_n(rst_n), //active low reset
  .in_trig(pause_db), // input trigger
  .out_pulse(pause_o) //  output , use as SET pb into chg_mode of counter
);
one_pulse U_OP_START(
  .clk(clk_100),  // clock input
  .rst_n(rst_n), //active low reset
  .in_trig(start_db), // input trigger
  .out_pulse(start_o) //  output , use as SET pb into chg_mode of counter
);

endmodule