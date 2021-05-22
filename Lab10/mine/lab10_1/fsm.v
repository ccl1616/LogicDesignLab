`define S0 1'b0
`define S1 1'b1

module fsm(
    input clk,
    input rst,
    input btn_op,
    output reg state,
);
reg state_next;

// state transition
always@* begin
    state_next = 1'b0;
    case(state)
    `S0: begin
        if(btn_op) 
            state_next = `S1;
        else state_next = `S0;
    end
    `S1: begin
        if(btn_op) 
            state_next = `S0;
        else state_next = `S1;
    end
end

// state register
always @(posedge clk or posedge rst)
    if(rst)
        state <= `S0;
    else 
        state <= state_next;
endmodule