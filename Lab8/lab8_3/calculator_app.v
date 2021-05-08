module calculator_app(
    input clk, 
    input rst,
    input wire [7:0]ascii,
    input newkey,
    output wire [3:0] show0,show1,show2,show3,
    output wire is_neg
);
//**************************************************************
// pre-calculate
wire is_enter, is_number;
wire [2:0] state;
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
number U_NUM(
    .clk(clk), 
    .rst(rst),
    .sel(state),
    .is_number(is_number),
    .char(char), 
    // output
    .dig0(dig0),
    .dig1(dig1),
    .dig2(dig2),
    .dig3(dig3)
);

//**************************************************************
// fsm block , real calculation
wire [13:0]result;
wire [3:0] re_dig0, re_dig1, re_dig2, re_dig3;
fsm U_FSM(
    .newkey(newkey),
    .clk(clk),
    .rst(rst),
    .is_number(is_number),
    .is_enter(is_enter), 
    .state(state)
);

wire is_add, is_subtract, is_multiple;
assign is_add = (opcode == 2'd01);
assign is_subtract = (opcode == 2'd10);
assign is_multiple = (opcode == 2'd11);
calculator U_CAL(
    .clk(clk),
    .rst(rst),
    .dig0(dig0),
    .dig1(dig1),
    .dig2(dig2),
    .dig3(dig3),
    .is_add(is_add), 
    .is_subtract(is_subtract), 
    .is_multiple(is_multiple), 
    .is_neg(is_neg),
    .result(result)
);
bin2bcd U_BIN2BCD(
    .bin(result),
    .bcd( {re_dig3, re_dig2, re_dig1, re_dig0} )
);

wire [3:0] show0,show1,show2,show3;
always@(*) begin
    if(state==3'd6)
        {show3,show2,show1,show0} = {re_dig3, re_dig2, re_dig1, re_dig0};
    else
        {show3,show2,show1,show0} = {dig3, dig2, dig1, dig0};
end

endmodule