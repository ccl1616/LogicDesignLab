// Listing 7.10
module sync_rw_port_ram
   #(
    parameter ADDR_WIDTH = 13, // number of address bits
              DATA_WIDTH = 7   // number of bits
   )
   (
    input  logic clk,
    input  logic we,
    input  logic [ADDR_WIDTH-1:0] addr_r, 
    input  logic [ADDR_WIDTH-1:0] addr_w, 
    input  logic [DATA_WIDTH-1:0] din,
    output logic [DATA_WIDTH-1:0] dout
   );

    // signal declaration
    logic [DATA_WIDTH-1:0] ram [0:2**ADDR_WIDTH-1];
    logic [DATA_WIDTH-1:0] data_reg;

    initial begin
      ram[13'b1000_0001] = 7'h32;
    end

    // body
    always_ff @(posedge clk)
    begin
      // write operation
      if (we)
          ram[addr_w] <= din;
      // read operation
      data_reg <= ram[addr_r];
    end
    // output
    assign dout = data_reg;
endmodule