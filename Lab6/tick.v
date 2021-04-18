module tick(
    clk,
    rst_n,
    initval,
    enable,
    load,
    // output
    tick
);
input clk,rst_n,enable,load;
input [`TICK_BIT_WIDTH-1:0]initval;
output reg tick;

reg count_next;
reg count;
always@* begin
    if(load)
        count_next = initval;
    else if(enable) 
        begin
            if(count == `TICK_DIV-1)
                count_next = `TICK_BIT_WIDTH'd0;
            else count_next = count+1;
        end
    else 
        count_next = count;
end

assign tick = (count == `TICK_DIV-1)?1'b1:1'b0;

always@(posedge clk or negedge rst_n)
begin
    if(~rst_n) count <= `TICK_BIT_WIDTH'd0;
    else count <= count_next;
end


endmodule