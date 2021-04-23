module interface(
    input clk,
    input rst_n,
    input switch,
    input pb_l,
    input pb_r,
    input pb_mode,
    // output 
    output switch_o,
    output pb_l_o,
    output pb_l_long_o,
    output pb_r_o,
    output pb_mode_o
);
debounce_circuit U_DB_DIP(
  .clk(clk), // clock control
  .rst_n(rst_n), // reset
  .pb_in(switch), //push button input
  .pb_debounced(switch_o) // debounced push button output
);

// onepulse
wire db_r,db_mode;
debounce_circuit U_DBR(
  .clk(clk), // clock control
  .rst_n(rst_n), // reset
  .pb_in(pb_r), //push button input
  .pb_debounced(db_r) // debounced push button output
);
debounce_circuit U_DBMODE(
  .clk(clk), // clock control
  .rst_n(rst_n), // reset
  .pb_in(pb_mode), //push button input
  .pb_debounced(db_mode) // debounced push button output
);
one_pulse U_OP_R(
  .clk(clk),  // clock input
  .rst_n(rst_n), //active low reset
  .in_trig(db_r), // input trigger
  .out_pulse(pb_r_o) //  output , use as SET pb into chg_mode of counter
);
one_pulse U_OP_MODE(
  .clk(clk),  // clock input
  .rst_n(rst_n), //active low reset
  .in_trig(db_mode), // input trigger
  .out_pulse(pb_mode_o) //  output , use as SET pb into chg_mode of counter
);

// short long press
wire db_l;
debounce_circuit U_DB_L(
  .clk(clk), // clock control
  .rst_n(rst_n), // reset
  .pb_in(pb_r), //push button input
  .pb_debounced(db_l) // debounced push button output
);
press U_P_L(
    .mode_in(db_l),
    .short_press(pb_l_o), 
    .long_press(pb_l_long_o),
    .clk(clk),  // clock input
    .rst_n(rst_n) //active low reset
);

endmodule