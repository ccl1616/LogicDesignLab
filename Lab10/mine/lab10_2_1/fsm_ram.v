`define ADDR_WIDTH 13
`define DATA_WIDTH 7
`define S_IDLE 3'd0
`define S1 3'd1
`define S2 3'd2
`define S3 3'd3
`define S4 3'd4

module fsm_ram(
    input clk,
    input rst,
    input [7:0] as0,as1,as2,as3,
    input newkey_op,
    output reg we,
    output reg [`ADDR_WIDTH-1:0] addr_w,
    output reg [`DATA_WIDTH-1:0] data,
    output reg [2:0] state
);

reg [2:0] next_state;

reg next_we;
reg [`ADDR_WIDTH-1:0] next_addr_w;
reg [`DATA_WIDTH-1:0] next_data; // AS form

// state transition
always@(*)begin
    case(state)
        `S_IDLE: begin
            if(newkey_op) next_state = `S1;
            else next_state = `S_IDLE;
        end
        `S1: next_state = `S_2;
        `S2: next_state = `S_3;
        `S3: next_state = `S_4;
        `S4: next_state = `S_IDLE;
        default: next_state = `S_IDLE;
        end
    endcase
end

// output
always@(*)begin
    case(state)
        `S_IDLE: begin
            next_we = 0;
            next_addr_w = {6'h1,7'h4};
            next_data = 7'h30;
        end
        `S1: begin
            next_we = 1;
            next_addr_w = {6'h1,7'h4};
            next_data = as0;
        end
        `S2: begin
            next_we = 1;
            next_addr_w = {6'h1,7'h3};
            next_data = as1;
        end
        `S3: begin
            next_we = 1;
            next_addr_w = {6'h1,7'h2};
            next_data = as2;
        end
        `S4: begin
            next_we = 1;
            next_addr_w = {6'h1,7'h1};
            next_data = as3;
        end
        default: begin
            next_we = 0;
            next_addr_w = {6'h1,7'h4};
            next_data = 7'h30;
        end
    endcase
end

// state ff
always @(posedge clk or posedge rst)
  if (rst) begin
    state <= `S_IDLE;
  end
  else begin
    state <= next_state;
  end

// output ff
always @(posedge clk or posedge rst)
  if (rst) begin
    we = 0;
    addr_w = {6'h1,7'h4};
    data = 7'h30;
  end
  else begin
    we = next_we;
    addr_w = next_addr_w;
    data = next_data;
  end
endmodule