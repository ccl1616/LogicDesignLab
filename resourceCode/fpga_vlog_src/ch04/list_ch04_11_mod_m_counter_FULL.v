// Listing 4.11 modified
module mod_m_counter_up
   #(
    parameter N=4, // number of bits in counter
              M=10 // mod-M
   )
   (
    input wire clk, preset,
    input wire en,
    output wire max_tick,
    output wire [N-1:0] q
   );
   localparam N_1 = N-1;
   //signal declaration
   reg [N_1:0] r_reg;
   wire [N_1:0] r_next;

   // body
   // register
   always @(posedge clk, posedge preset)
    begin : MOD_UP
      if (preset)
      begin
         r_reg <= {N{1'b1}} ; // {N{1'b0}} {N_1{1'b0},1'b1}
      end
      else if ( en )
         r_reg <= r_next;
      else
         r_reg <= r_reg;
    end
   // next-state logic
   assign r_next = (max_tick) ? ~M + 1 : r_reg + 1 ; // complement assignment
   // output logic
   assign q = r_reg;
   assign max_tick = (r_reg==(2**N-1)) ? 1'b1 : 1'b0;

endmodule

module mod_m_counter_down
   #(
    parameter N=4, // number of bits in counter
              M=10 // mod-M
   )
   (
    input wire clk, reset,
    input wire en,
    output wire min_tick,
    output wire [N-1:0] q
   );

   //signal declaration
   reg [N-1:0] r_reg;
   wire [N-1:0] r_next;

   // body
   // register
   always @(posedge clk, posedge reset)
    begin : MOD_DOWN
      if (reset)
         r_reg <= {N{1'b0}} ; // {N{1'b0}} 
      else if ( en )
         r_reg <= r_next;
      else
         r_reg <= r_reg;
    end
   // next-state logic
   assign r_next = (min_tick) ? M - 1 : r_reg - 1; // M rout through -1 in stead to FF directly
   // output logic
   assign q = r_reg;
   assign min_tick = (r_reg=={N{1'b0}}) ? 1'b1 : 1'b0;

endmodule