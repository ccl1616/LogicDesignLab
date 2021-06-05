`define ADDR_WIDTH 13, // number of address bits
`define DATA_WIDTH 7   // number of bits

`define S_IDLE 3'd0
`define S0 3'd0
`define S1 3'd1
`define S2 3'd2
`define S3 3'd3

module fsm_write_data(
    input [`DATA_WIDTH-1:0] as0,as1,as2,as3,
    input newkey_op,
    input clk,rst,
    output reg [2:0]state,
    output reg we, // write enable
    output reg [`ADDR_WIDTH-1:0] addr_w,
    output reg [`DATA_WIDTH-1:0] data // 7 bit
);
reg [2:0] next_state;
reg next_we;
reg [`ADDR_WIDTH-1:0] next_addr_w;
reg [`DATA_WIDTH-1:0] next_data;

// state ff
always@(posedge clk or posedge rst) begin
    if(rst)
        state <= `S_IDLE;
    else 
        state <= next_state;
end

// output ff
always@(posedge clk or posedge rst) begin
    if(rst) begin
        addr_w <= 0;
        data <= 0;
        we <= 0;
    end
    else begin 
        addr_w = next_addr_w;
        data <= next_data;
        we <= next_we;
    end
end

// state transition
always@(posedge clk) begin
    case(state)
        `S_IDLE:
            begin
                if(newkey_op) next_state = `S0;
                else next_state = `S_IDLE;
            end
        `S0: next_state = `S1;
        `S1: next_state = `S2;
        `S2: next_state = `S3;
        `S3: next_state = `S_IDLE;
    endcase
end

// output
// addr : y,x
always@(posedge clk) begin
    case(state)
        `S_IDLE: 
            begin
                next_addr_w = {6'h1,7'h4};
                data = 0;
                next_we = 0;
            end
        `S0: begin
                next_addr_w = {6'h1,7'h4};
                next_data = 7'as0;
                next_we = 1;
            end
        `S1: begin
                next_addr_w = {6'h1,7'h3};
                next_data = 7'as1;
                next_we = 1;
            end
        `S2: begin
                next_addr_w = {6'h1,7'h2};
                next_data = 7'as2;
                next_we = 1;
            end
        `S3: begin
                next_addr_w = {6'h1,7'h1};
                next_data = 7'as3;
                next_we = 1;
            end
    endcase
end
endmodule