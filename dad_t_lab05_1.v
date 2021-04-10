`timescale 1ns / 1ps 

`include "global.v" 


module t_lab05_1;

reg clk, rst_n;
wire [`SSD_NUM-1:0] an; // scan control for 7-segment display
wire [`SSD_BIT_WIDTH-2:0] seg; // 7-segment display
wire [9:0] led; // 10 LEDs
wire sdp; 
reg pb_start, pb_set;
wire pb_mode; 
reg count_ena;
wire pb_start_debounced = U0.pb_start_debounced;

lab05_1_top U0(
 .led( led ),
 .seg( seg ), .sdp( sdp ), // 7-segment display
 .an( an ), // scan control for 7-segment display
 .pb_start( pb_start ), .pb_set( pb_set ), .pb_mode( pb_mode ),
 .clk( clk ),  .rst_n( rst_n ) // active low reset
);

assign pb_mode = pb_set; // pb_mode same as pb_set

`define CYCLE 10
always #(`CYCLE/2) clk=~clk; 
initial 
begin
  clk=1; rst_n=0; pb_start=0; pb_set=1; count_ena=1; 
  #(`CYCLE +1) rst_n=1;
  pb_set=0;
  // --------------------------------------------------
  repeat (5) @( posedge clk ) ;
  pb_set=1; pb_start=0;  ;   // set counting again
    repeat (1) @( posedge clk ) ; // on purposely // set start delay after set
    pb_set=1; pb_start=1; 
  //#((`CYCLE) * (17'h10));  // Release all button after pb_set debouned ok and generate the successful "pb_debounced"
  @( posedge pb_start_debounced) ; // after target signal trigger // extend one cycle
  repeat (1) @( posedge clk ) ;   pb_set=0; pb_start=0; count_ena=0;
// --------------------------------------------
  repeat (2) @( posedge clk ) ;   pb_set=1; pb_start=1; // Start counting
  repeat (10) @( posedge clk );   pb_set=0; pb_start=0;
//  -------------------------------------------
  repeat (10) @( posedge clk );   pb_set=0; pb_start=1; // Pause
  @( posedge pb_start_debounced) ; // after target signal trigger // extend one cycle
  repeat (1) @( posedge clk ) ;   pb_set=0; pb_start=0;
  @( negedge pb_start_debounced) ; // after target signal trigger // extend one cycle
  repeat (2) @( posedge clk ) ;   pb_set=0; pb_start=1; // push start again
  @( posedge pb_start_debounced) ; // after target signal trigger // extend one cycle
  repeat (2) @( posedge clk ) ;   pb_set=0; pb_start=0;
  @( negedge pb_start_debounced) ; // after target signal trigger // extend one cycle
//  -------------------------------------------
  repeat (2) @( posedge clk ) ;   pb_set=1; pb_start=0; // set mode after 2 cycles
  //
    #((`CYCLE) * (17'h4));
    pb_set=1; pb_start=1; // set start delay after set
  #((`CYCLE) * (17'h10));  // Release all button
  pb_set=0; pb_start=0; count_ena=0;
  
end

// assign U0.count_ena=count_ena;
//initial
//begin
////  $readmemb("C:/Users/hp/LD/shiftreg/shiftreg.srcs/sim_1/new/golden.txt", testvectors);
  //$readmemb("t_golden.txt", testvectors);
  //vectornum=0;
//end

endmodule