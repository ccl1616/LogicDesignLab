module calculator_app(
    input clk, 
    input rst,
    input wire [7:0]ascii,
    input newkey,
    output wire [3:0] show0,show1,show2,show3,
    output wire [2:0]state,
    output wire is_neg
);
//**************************************************************
// pre-calculate
wire is_enter, is_number;
// wire [2:0] state;
wire [3:0] dig0,dig1,dig2,dig3;
wire [1:0] opcode;
wire [3:0] char;

identify U_IDENT(
    .clk(clk), 
    .rst(rst),
    .ascii(ascii),
    // output
    .opcode(opcode),
    .is_enter(is_enter), 
    .is_number(is_number),
    .char(char)
);

//**************************************************************
// fsm block , real calculation
wire [13:0]result;

fsm_new U_FSM_NEW(
    .newkey(newkey),
    .clk(clk),
    .rst(rst),
    .is_number(is_number),
    .is_enter(is_enter), 
    .state(state)
);

wire [13:0]first, second;
cal_new U_CAL_NEW(
    .clk(clk),
    .rst(rst),
    .char(char),
    .state(state),
    .is_number(is_number),
    .opcode(opcode),
    .newkey(newkey),
    .first(first),
    .second(second),
    .is_neg(is_neg),
    .result(result)
);
reg [13:0] big_show;
always@(*) begin
    if(state==3'd0) big_show = first;
    else if(state==3'd1) big_show = second;
    else big_show = result;
end
bin2bcd U_BIN2BCD(
    .bin(big_show),
    .bcd( {show3,show2,show1,show0} )
);

endmodule