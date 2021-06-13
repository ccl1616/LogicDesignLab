`include "global.vh"
`define silence   32'd50000000


`define ha  32'd440   // A4
`define hha 32'd880   // A5
`define hb  32'd494   // B4
`define hc  32'd524   // C4
`define hd  32'd588   // D4
`define he  32'd660   // E4
`define hf  32'd698   // F4
`define hg  32'd784   // G4
`define c   32'd262   // C3
`define g   32'd392   // G3
`define b   32'd494   // B3
`define d   32'd294   // D3
`define e   32'd330   // E3
`define f   32'd349
`define lc  32'd131   // C2
`define ld  32'd147   // D2
`define le  32'd165   // E2
`define lf  32'd174   // F2
`define lg  32'd196   // G2
`define la  32'd220   // A2
`define lb  32'd247   // B2
`define lla 32'd110   // A2
`define llg 32'd100   // G1
`define sil   32'd50000000 // slience

`define A 3'b001
`define B 3'b010
`define C 3'b011
`define D 3'b100
`define E 3'b101
`define F 3'b110
`define G 3'b111

module debounce (pb_debounced, pb, clk);
    output pb_debounced; // output after being debounced
    input pb; // input from a pushbutton
    input clk;
    reg [3:0] shift_reg; // use shift_reg to filter the bounce
    always@(posedge clk)
        begin
            shift_reg[3:1] <= shift_reg[2:0];
            shift_reg[0] <= pb;
        end
    assign pb_debounced = ((shift_reg == 4'b1111) ? 1'b1 : 1'b0);
endmodule

module player_control (
    input clk,
    input reset,
    input wire [4:0] music,
    output reg [11:0] ibeat
);
    parameter LEN = 1024;
    parameter _LEN = 512;
    parameter INITIAL = 2'd0;
    parameter FIRST = 2'd1;
    parameter SECOND = 2'd2;
    reg [11:0] next_ibeat;
    reg [1:0] _state, _next_state;

    always @(posedge clk, posedge reset) begin
        if (reset) begin
            ibeat <= 0;
            _state <= INITIAL;
        end
        else begin
            ibeat <= next_ibeat;
            _state <= _next_state;
        end
    end

    always @* begin
        _next_state = _state;
        next_ibeat = ibeat;
        case(_state)
            INITIAL: begin
                if(music == `INI) begin
                    _next_state = FIRST;
                end
                else begin
                    _next_state = SECOND;
                end
            end
            FIRST: begin
                next_ibeat = (ibeat + 1 < LEN) ? (ibeat + 1) : 12'd0;
            end
            SECOND: begin
                next_ibeat = (ibeat + 1 < _LEN) ? (ibeat + 1) : 12'd0;
            end
        endcase
    end

endmodule

module note_gen(
    clk, // clock from crystal
    rst, // active high reset
    note_div_left, // div for note generation
    note_div_right,
    audio_left,
    audio_right,
    volume
);

    // I/O declaration
    input clk; // clock from crystal
    input rst; // active low reset
    input [21:0] note_div_left, note_div_right; // div for note generation
    output [15:0] audio_left, audio_right;
    input [2:0] volume;

    // Declare internal signals
    reg [21:0] clk_cnt_next, clk_cnt;
    reg [21:0] clk_cnt_next_2, clk_cnt_2;
    reg b_clk, b_clk_next;
    reg c_clk, c_clk_next;

    // Note frequency generation
    always @(posedge clk or posedge rst)
        if (rst == 1'b1)
            begin
                clk_cnt <= 22'd0;
                clk_cnt_2 <= 22'd0;
                b_clk <= 1'b0;
                c_clk <= 1'b0;
            end
        else
            begin
                clk_cnt <= clk_cnt_next;
                clk_cnt_2 <= clk_cnt_next_2;
                b_clk <= b_clk_next;
                c_clk <= c_clk_next;
            end

    always @*
        if (clk_cnt == note_div_left)
            begin
                clk_cnt_next = 22'd0;
                b_clk_next = ~b_clk;
            end
        else
            begin
                clk_cnt_next = clk_cnt + 1'b1;
                b_clk_next = b_clk;
            end

    always @*
        if (clk_cnt_2 == note_div_right)
            begin
                clk_cnt_next_2 = 22'd0;
                c_clk_next = ~c_clk;
            end
        else
            begin
                clk_cnt_next_2 = clk_cnt_2 + 1'b1;
                c_clk_next = c_clk;
            end

    // Assign the amplitude of the note
    // Volume is controlled here
    assign audio_left = (b_clk == 1'b0 && volume == 3'd1) ? 16'hE666 : //1999
                        (b_clk == 1'b1 && volume == 3'd1) ? 16'h1999 :
                        (b_clk == 1'b0 && volume == 3'd2) ? 16'hAAAB : //3333
                        (b_clk == 1'b1 && volume == 3'd2) ? 16'h3333 :
                        (b_clk == 1'b0 && volume == 3'd3) ? 16'hB334 : //4CCC
                        (b_clk == 1'b1 && volume == 3'd3) ? 16'h4CCC :
                        (b_clk == 1'b0 && volume == 3'd4) ? 16'h999A : // 6666
                        (b_clk == 1'b1 && volume == 3'd4) ? 16'h6666 :
                        (b_clk == 1'b0 && volume == 3'd5) ? 16'h8001 : 16'h7FFF;
    assign audio_right = (c_clk == 1'b0 && volume == 3'd1) ? 16'hE666 : //1999
                         (c_clk == 1'b1 && volume == 3'd1) ? 16'h1999 :
                         (c_clk == 1'b0 && volume == 3'd2) ? 16'hAAAB : //3333
                         (c_clk == 1'b1 && volume == 3'd2) ? 16'h3333 :
                         (c_clk == 1'b0 && volume == 3'd3) ? 16'hB334 : //4CCC
                         (c_clk == 1'b1 && volume == 3'd3) ? 16'h4CCC :
                         (c_clk == 1'b0 && volume == 3'd4) ? 16'h999A : // 6666
                         (c_clk == 1'b1 && volume == 3'd4) ? 16'h6666 :
                         (c_clk == 1'b0 && volume == 3'd5) ? 16'h8001 : 16'h7FFF;
endmodule

module music_example (
    input [11:0] ibeatNum,
    input [4:0] state,
    output reg [31:0] toneL,
    output reg [31:0] toneR,
    output reg [31:0] _toneL,
    output reg [31:0] _toneR
);

//first song
    always @* begin
        if(state == `INI) begin
            toneR = `sil;
        /*
            case(ibeatNum)
                // --- Measure 1 ---
                12'd0: toneR = `he;      12'd1: toneR = `he; // HG (half-beat)
                12'd2: toneR = `he;      12'd3: toneR = `he;
                12'd4: toneR = `he;      12'd5: toneR = `he;
                12'd6: toneR = `he;      12'd7: toneR = `he;
                12'd8: toneR = `he;      12'd9: toneR = `he; // HE (half-beat)
                12'd10: toneR = `he;     12'd11: toneR = `he;
                12'd12: toneR = `he;     12'd13: toneR = `he;
                12'd14: toneR = `he;     12'd15: toneR = `he; // (Short break for repetitive notes: high E)

                12'd16: toneR = `hb;     12'd17: toneR = `hb; // HE (one-beat)
                12'd18: toneR = `hb;     12'd19: toneR = `hb;
                12'd20: toneR = `hb;     12'd21: toneR = `hb;
                12'd22: toneR = `hb;     12'd23: toneR = `hb;
                12'd24: toneR = `hc;     12'd25: toneR = `hc;
                12'd26: toneR = `hc;     12'd27: toneR = `hc;
                12'd28: toneR = `hc;     12'd29: toneR = `hc;
                12'd30: toneR = `hc;     12'd31: toneR = `hc;

                12'd32: toneR = `hd;     12'd33: toneR = `hd; // HF (half-beat)
                12'd34: toneR = `hd;     12'd35: toneR = `hd;
                12'd36: toneR = `hd;     12'd37: toneR = `hd;
                12'd38: toneR = `hd;     12'd39: toneR = `hd;
                12'd40: toneR = `he;     12'd41: toneR = `he; // HD (half-beat)
                12'd42: toneR = `he;     12'd43: toneR = `he;
                12'd44: toneR = `hd;     12'd45: toneR = `hd;
                12'd46: toneR = `hd;     12'd47: toneR = `hd; // (Short break for repetitive notes: high D)

                12'd48: toneR = `hc;     12'd49: toneR = `hc; // HD (one-beat)
                12'd50: toneR = `hc;     12'd51: toneR = `hc;
                12'd52: toneR = `hc;     12'd53: toneR = `hc;
                12'd54: toneR = `hc;     12'd55: toneR = `hc;
                12'd56: toneR = `hb;     12'd57: toneR = `hb;
                12'd58: toneR = `hb;     12'd59: toneR = `hb;
                12'd60: toneR = `hb;     12'd61: toneR = `hb;
                12'd62: toneR = `hb;     12'd63: toneR = `hb;

                // --- Measure 2 ---
                12'd64: toneR = `ha;     12'd65: toneR = `ha; // HC (half-beat)
                12'd66: toneR = `ha;     12'd67: toneR = `ha;
                12'd68: toneR = `ha;     12'd69: toneR = `ha;
                12'd70: toneR = `ha;     12'd71: toneR = `ha;
                12'd72: toneR = `ha;     12'd73: toneR = `ha; // HD (half-beat)
                12'd74: toneR = `ha;     12'd75: toneR = `ha;
                12'd76: toneR = `ha;     12'd77: toneR = `ha;
                12'd78: toneR = `ha;     12'd79: toneR = `ha;

                12'd80: toneR = `ha;     12'd81: toneR = `ha; // HE (half-beat)
                12'd82: toneR = `ha;     12'd83: toneR = `ha;
                12'd84: toneR = `ha;     12'd85: toneR = `ha;
                12'd86: toneR = `ha;     12'd87: toneR = `ha;
                12'd88: toneR = `hc;     12'd89: toneR = `hc; // HF (half-beat)
                12'd90: toneR = `hc;     12'd91: toneR = `hc;
                12'd92: toneR = `hc;     12'd93: toneR = `hc;
                12'd94: toneR = `hc;     12'd95: toneR = `hc;

                12'd96: toneR = `he;     12'd97: toneR = `he; // HG (half-beat)
                12'd98: toneR = `he;     12'd99: toneR = `he;
                12'd100: toneR = `he;     12'd101: toneR = `he;
                12'd102: toneR = `he;     12'd103: toneR = `he; // (Short break for repetitive notes: high D)
                12'd104: toneR = `he;     12'd105: toneR = `he; // HG (half-beat)
                12'd106: toneR = `he;     12'd107: toneR = `he;
                12'd108: toneR = `he;     12'd109: toneR = `he;
                12'd110: toneR = `he;     12'd111: toneR = `he; // (Short break for repetitive notes: high D)

                12'd112: toneR = `hd;     12'd113: toneR = `hd; // HG (one-beat)
                12'd114: toneR = `hd;     12'd115: toneR = `hd;
                12'd116: toneR = `hd;     12'd117: toneR = `hd;
                12'd118: toneR = `hd;     12'd119: toneR = `hd;
                12'd120: toneR = `hc;     12'd121: toneR = `hc;
                12'd122: toneR = `hc;     12'd123: toneR = `hc;
                12'd124: toneR = `hc;     12'd125: toneR = `hc;
                12'd126: toneR = `hc;     12'd127: toneR = `hc;

                // --- Measure 3 ---
                12'd128: toneR = `hb;   12'd129: toneR = `hb;
                12'd130: toneR = `hb;   12'd131: toneR = `hb;
                12'd132: toneR = `hb;   12'd133: toneR = `hb;
                12'd134: toneR = `hb;   12'd135: toneR = `hb;
                12'd136: toneR = `hb;   12'd137: toneR = `hb;
                12'd138: toneR = `hb;   12'd139: toneR = `hb;
                12'd140: toneR = `hb;   12'd141: toneR = `hb;
                12'd142: toneR = `hb;   12'd143: toneR = `sil;

                12'd144: toneR = `hb;   12'd145: toneR = `hb;
                12'd146: toneR = `hb;   12'd147: toneR = `sil;
                12'd148: toneR = `hb;   12'd149: toneR = `hb;
                12'd150: toneR = `hb;   12'd151: toneR = `hb;
                12'd152: toneR = `hc;   12'd153: toneR = `hc;
                12'd154: toneR = `hc;   12'd155: toneR = `hc;
                12'd156: toneR = `hc;   12'd157: toneR = `hc;
                12'd158: toneR = `hc;   12'd159: toneR = `hc;

                12'd160: toneR = `hd;   12'd161: toneR = `hd;
                12'd162: toneR = `hd;   12'd163: toneR = `hd;
                12'd164: toneR = `hd;   12'd165: toneR = `hd;
                12'd166: toneR = `hd;   12'd167: toneR = `hd;
                12'd168: toneR = `hd;   12'd169: toneR = `hd;
                12'd170: toneR = `hd;   12'd171: toneR = `hd;
                12'd172: toneR = `hd;   12'd173: toneR = `hd;
                12'd174: toneR = `hd;   12'd175: toneR = `hd;

                12'd176: toneR = `he;   12'd177: toneR = `he;
                12'd178: toneR = `he;   12'd179: toneR = `he;
                12'd180: toneR = `he;   12'd181: toneR = `he;
                12'd182: toneR = `he;   12'd183: toneR = `he;
                12'd184: toneR = `he;   12'd185: toneR = `he;
                12'd186: toneR = `he;   12'd187: toneR = `he;
                12'd188: toneR = `he;   12'd189: toneR = `he;
                12'd190: toneR = `he;   12'd191: toneR = `he;

                // --- Measure 4 ---
                12'd192: toneR = `hc;   12'd193: toneR = `hc;
                12'd194: toneR = `hc;   12'd195: toneR = `hc;
                12'd196: toneR = `hc;   12'd197: toneR = `hc;
                12'd198: toneR = `hc;   12'd199: toneR = `hc;
                12'd200: toneR = `hc;   12'd201: toneR = `hc;
                12'd202: toneR = `hc;   12'd203: toneR = `hc;
                12'd204: toneR = `hc;   12'd205: toneR = `hc;
                12'd206: toneR = `hc;   12'd207: toneR = `hc;

                12'd208: toneR = `ha;   12'd209: toneR = `ha;
                12'd210: toneR = `ha;   12'd211: toneR = `ha;
                12'd212: toneR = `ha;   12'd213: toneR = `ha;
                12'd214: toneR = `ha;   12'd215: toneR = `ha;
                12'd216: toneR = `ha;   12'd217: toneR = `ha;
                12'd218: toneR = `ha;   12'd219: toneR = `ha;
                12'd220: toneR = `ha;   12'd221: toneR = `ha;
                12'd222: toneR = `ha;   12'd223: toneR = `sil;

                12'd224: toneR = `ha;   12'd225: toneR = `ha;
                12'd226: toneR = `ha;   12'd227: toneR = `ha;
                12'd228: toneR = `ha;   12'd229: toneR = `ha;
                12'd230: toneR = `ha;   12'd231: toneR = `ha;
                12'd232: toneR = `ha;   12'd233: toneR = `ha;
                12'd234: toneR = `ha;   12'd235: toneR = `ha;
                12'd236: toneR = `ha;   12'd237: toneR = `ha;
                12'd238: toneR = `ha;   12'd239: toneR = `ha;

                12'd240: toneR = `ha;   12'd241: toneR = `ha;
                12'd242: toneR = `ha;   12'd243: toneR = `ha;
                12'd244: toneR = `ha;   12'd245: toneR = `ha;
                12'd246: toneR = `ha;   12'd247: toneR = `ha;
                12'd248: toneR = `ha;   12'd249: toneR = `ha;
                12'd250: toneR = `ha;   12'd251: toneR = `ha;
                12'd252: toneR = `ha;   12'd253: toneR = `ha;
                12'd254: toneR = `ha;   12'd255: toneR = `ha;

                // --- Measure 5 ---
                12'd256: toneR = `hd;   12'd257: toneR = `hd;
                12'd258: toneR = `hd;   12'd259: toneR = `hd;
                12'd260: toneR = `hd;   12'd261: toneR = `hd;
                12'd262: toneR = `hd;   12'd263: toneR = `hd;
                12'd264: toneR = `hd;   12'd265: toneR = `hd;
                12'd266: toneR = `hd;   12'd267: toneR = `hd;
                12'd268: toneR = `hd;   12'd269: toneR = `hd;
                12'd270: toneR = `hd;   12'd271: toneR = `sil;

                12'd272: toneR = `hd;   12'd273: toneR = `hd;
                12'd274: toneR = `hd;   12'd275: toneR = `hd;
                12'd276: toneR = `hd;   12'd277: toneR = `hd;
                12'd278: toneR = `hd;   12'd279: toneR = `hd;
                12'd280: toneR = `hf;   12'd281: toneR = `hf;
                12'd282: toneR = `hf;   12'd283: toneR = `hf;
                12'd284: toneR = `hf;   12'd285: toneR = `hf;
                12'd286: toneR = `hf;   12'd287: toneR = `hf;

                12'd288: toneR = `hha;   12'd289: toneR = `hha;
                12'd290: toneR = `hha;   12'd291: toneR = `hha;
                12'd292: toneR = `hha;   12'd293: toneR = `hha;
                12'd294: toneR = `hha;   12'd295: toneR = `hha;
                12'd296: toneR = `hha;   12'd297: toneR = `hha;
                12'd298: toneR = `hha;   12'd299: toneR = `hha;
                12'd300: toneR = `hha;   12'd301: toneR = `hha;
                12'd302: toneR = `hha;   12'd303: toneR = `hha;

                12'd304: toneR = `hg;   12'd305: toneR = `hg;
                12'd306: toneR = `hg;   12'd307: toneR = `hg;
                12'd308: toneR = `hg;   12'd309: toneR = `hg;
                12'd310: toneR = `hg;   12'd311: toneR = `hg;
                12'd312: toneR = `hf;   12'd313: toneR = `hf;
                12'd314: toneR = `hf;   12'd315: toneR = `hf;
                12'd316: toneR = `hf;   12'd317: toneR = `hf;
                12'd318: toneR = `hf;   12'd319: toneR = `hf;

                // --- Measure 6 ---
                12'd320: toneR = `he;   12'd321: toneR = `he;
                12'd322: toneR = `he;   12'd323: toneR = `he;
                12'd324: toneR = `he;   12'd325: toneR = `he;
                12'd326: toneR = `he;   12'd327: toneR = `he;
                12'd328: toneR = `he;   12'd329: toneR = `he;
                12'd330: toneR = `he;   12'd331: toneR = `he;
                12'd332: toneR = `he;   12'd333: toneR = `he;
                12'd334: toneR = `he;   12'd335: toneR = `he;

                12'd336: toneR = `he;   12'd337: toneR = `he;
                12'd338: toneR = `he;   12'd339: toneR = `he;
                12'd340: toneR = `he;   12'd341: toneR = `he;
                12'd342: toneR = `he;   12'd343: toneR = `he;
                12'd344: toneR = `hc;   12'd345: toneR = `hc;
                12'd346: toneR = `hc;   12'd347: toneR = `hc;
                12'd348: toneR = `hc;   12'd349: toneR = `hc;
                12'd350: toneR = `hc;   12'd351: toneR = `hc;

                12'd352: toneR = `he;   12'd353: toneR = `he;
                12'd354: toneR = `he;   12'd355: toneR = `he;
                12'd356: toneR = `he;   12'd357: toneR = `he;
                12'd358: toneR = `he;   12'd359: toneR = `he;
                12'd360: toneR = `he;   12'd361: toneR = `he;
                12'd362: toneR = `he;   12'd363: toneR = `he;
                12'd364: toneR = `he;   12'd365: toneR = `he;
                12'd366: toneR = `he;   12'd367: toneR = `he;

                12'd368: toneR = `hd;   12'd369: toneR = `hd;
                12'd370: toneR = `hd;   12'd371: toneR = `hd;
                12'd372: toneR = `hd;   12'd373: toneR = `hd;
                12'd374: toneR = `hd;   12'd375: toneR = `hd;
                12'd376: toneR = `hc;   12'd377: toneR = `hc;
                12'd378: toneR = `hc;   12'd379: toneR = `hc;
                12'd380: toneR = `hc;   12'd381: toneR = `hc;
                12'd382: toneR = `hc;   12'd383: toneR = `hc;

                // --- Measure 7 ---
                12'd384: toneR = `hb;   12'd385: toneR = `hb;
                12'd386: toneR = `hb;   12'd387: toneR = `hb;
                12'd388: toneR = `hb;   12'd389: toneR = `hb;
                12'd390: toneR = `hb;   12'd391: toneR = `hb;
                12'd392: toneR = `hb;   12'd393: toneR = `hb;
                12'd394: toneR = `hb;   12'd395: toneR = `hb;
                12'd396: toneR = `hb;   12'd397: toneR = `hb;
                12'd398: toneR = `hb;   12'd399: toneR = `sil;

                12'd400: toneR = `hb;   12'd401: toneR = `hb;
                12'd402: toneR = `hb;   12'd403: toneR = `sil;
                12'd404: toneR = `hb;   12'd405: toneR = `hb;
                12'd406: toneR = `hb;   12'd407: toneR = `hb;
                12'd408: toneR = `hc;   12'd409: toneR = `hc;
                12'd410: toneR = `hc;   12'd411: toneR = `hc;
                12'd412: toneR = `hc;   12'd413: toneR = `hc;
                12'd414: toneR = `hc;   12'd415: toneR = `hc;

                12'd416: toneR = `hd;   12'd417: toneR = `hd;
                12'd418: toneR = `hd;   12'd419: toneR = `hd;
                12'd420: toneR = `hd;   12'd421: toneR = `hd;
                12'd422: toneR = `hd;   12'd423: toneR = `hd;
                12'd424: toneR = `hd;   12'd425: toneR = `hd;
                12'd426: toneR = `hd;   12'd427: toneR = `hd;
                12'd428: toneR = `hd;   12'd429: toneR = `hd;
                12'd430: toneR = `hd;   12'd431: toneR = `hd;

                12'd432: toneR = `he;   12'd433: toneR = `he;
                12'd434: toneR = `he;   12'd435: toneR = `he;
                12'd436: toneR = `he;   12'd437: toneR = `he;
                12'd438: toneR = `he;   12'd439: toneR = `he;
                12'd440: toneR = `he;   12'd441: toneR = `he;
                12'd442: toneR = `he;   12'd443: toneR = `he;
                12'd444: toneR = `he;   12'd445: toneR = `he;
                12'd446: toneR = `he;   12'd447: toneR = `he;

                // --- Measure 8 ---
                12'd448: toneR = `hc;   12'd449: toneR = `hc;
                12'd450: toneR = `hc;   12'd451: toneR = `hc;
                12'd452: toneR = `hc;   12'd453: toneR = `hc;
                12'd454: toneR = `hc;   12'd455: toneR = `hc;
                12'd456: toneR = `hc;   12'd457: toneR = `hc;
                12'd458: toneR = `hc;   12'd459: toneR = `hc;
                12'd460: toneR = `hc;   12'd461: toneR = `hc;
                12'd462: toneR = `hc;   12'd463: toneR = `hc;

                12'd464: toneR = `ha;   12'd465: toneR = `ha;
                12'd466: toneR = `ha;   12'd467: toneR = `ha;
                12'd468: toneR = `ha;   12'd469: toneR = `ha;
                12'd470: toneR = `ha;   12'd471: toneR = `ha;
                12'd472: toneR = `ha;   12'd473: toneR = `ha;
                12'd474: toneR = `ha;   12'd475: toneR = `ha;
                12'd476: toneR = `ha;   12'd477: toneR = `ha;
                12'd478: toneR = `ha;   12'd479: toneR = `sil;

                12'd480: toneR = `ha;   12'd481: toneR = `ha;
                12'd482: toneR = `ha;   12'd483: toneR = `ha;
                12'd484: toneR = `ha;   12'd485: toneR = `ha;
                12'd486: toneR = `ha;   12'd487: toneR = `ha;
                12'd488: toneR = `ha;   12'd489: toneR = `ha;
                12'd490: toneR = `ha;   12'd491: toneR = `ha;
                12'd492: toneR = `ha;   12'd493: toneR = `ha;
                12'd494: toneR = `ha;   12'd495: toneR = `ha;

                12'd496: toneR = `ha;   12'd497: toneR = `ha;
                12'd498: toneR = `ha;   12'd499: toneR = `ha;
                12'd500: toneR = `ha;   12'd501: toneR = `ha;
                12'd502: toneR = `ha;   12'd503: toneR = `ha;
                12'd504: toneR = `ha;   12'd505: toneR = `ha;
                12'd506: toneR = `ha;   12'd507: toneR = `ha;
                12'd508: toneR = `ha;   12'd509: toneR = `ha;
                12'd510: toneR = `ha;   12'd511: toneR = `ha;
                // --- Measure 9 ---
                12'd512: toneR = `he;   12'd513: toneR = `he;
                12'd514: toneR = `he;   12'd515: toneR = `he;
                12'd516: toneR = `he;   12'd517: toneR = `he;
                12'd518: toneR = `he;   12'd519: toneR = `he;
                12'd520: toneR = `he;   12'd521: toneR = `he;
                12'd522: toneR = `he;   12'd523: toneR = `he;
                12'd524: toneR = `he;   12'd525: toneR = `he;
                12'd526: toneR = `he;   12'd527: toneR = `he;

                12'd528: toneR = `hb;   12'd529: toneR = `hb;
                12'd530: toneR = `hb;   12'd531: toneR = `hb;
                12'd532: toneR = `hb;   12'd533: toneR = `hb;
                12'd534: toneR = `hb;   12'd535: toneR = `hb;
                12'd536: toneR = `hc;   12'd537: toneR = `hc;
                12'd538: toneR = `hc;   12'd539: toneR = `hc;
                12'd540: toneR = `hc;   12'd541: toneR = `hc;
                12'd542: toneR = `hc;   12'd543: toneR = `hc;

                12'd544: toneR = `hd;   12'd545: toneR = `hd;
                12'd546: toneR = `hd;   12'd547: toneR = `hd;
                12'd548: toneR = `hd;   12'd549: toneR = `hd;
                12'd550: toneR = `hd;   12'd551: toneR = `hd;
                12'd552: toneR = `he;   12'd553: toneR = `he;
                12'd554: toneR = `he;   12'd555: toneR = `he;
                12'd556: toneR = `hd;   12'd557: toneR = `hd;
                12'd558: toneR = `hd;   12'd559: toneR = `hd;

                12'd560: toneR = `hc;   12'd561: toneR = `hc;
                12'd562: toneR = `hc;   12'd563: toneR = `hc;
                12'd564: toneR = `hc;   12'd565: toneR = `hc;
                12'd566: toneR = `hc;   12'd567: toneR = `hc;
                12'd568: toneR = `hb;   12'd569: toneR = `hb;
                12'd570: toneR = `hb;   12'd571: toneR = `hb;
                12'd572: toneR = `hb;   12'd573: toneR = `hb;
                12'd574: toneR = `hb;   12'd575: toneR = `hb;

                // --- Measure 10 ---
                12'd576: toneR = `ha;   12'd577: toneR = `ha;
                12'd578: toneR = `ha;   12'd579: toneR = `ha;
                12'd580: toneR = `ha;   12'd581: toneR = `ha;
                12'd582: toneR = `ha;   12'd583: toneR = `ha;
                12'd584: toneR = `ha;   12'd585: toneR = `ha;
                12'd586: toneR = `ha;   12'd587: toneR = `ha;
                12'd588: toneR = `ha;   12'd589: toneR = `ha;
                12'd590: toneR = `ha;   12'd591: toneR = `sil;

                12'd592: toneR = `ha;   12'd593: toneR = `ha;
                12'd594: toneR = `ha;   12'd595: toneR = `ha;
                12'd596: toneR = `ha;   12'd597: toneR = `ha;
                12'd598: toneR = `ha;   12'd599: toneR = `ha;
                12'd600: toneR = `hc;   12'd601: toneR = `hc;
                12'd602: toneR = `hc;   12'd603: toneR = `hc;
                12'd604: toneR = `hc;   12'd605: toneR = `hc;
                12'd606: toneR = `hc;   12'd607: toneR = `hc;

                12'd608: toneR = `he;   12'd609: toneR = `he;
                12'd610: toneR = `he;   12'd611: toneR = `he;
                12'd612: toneR = `he;   12'd613: toneR = `he;
                12'd614: toneR = `he;   12'd615: toneR = `he;
                12'd616: toneR = `he;   12'd617: toneR = `he;
                12'd618: toneR = `he;   12'd619: toneR = `he;
                12'd620: toneR = `he;   12'd621: toneR = `he;
                12'd622: toneR = `he;   12'd623: toneR = `he;

                12'd624: toneR = `hd;   12'd625: toneR = `hd;
                12'd626: toneR = `hd;   12'd627: toneR = `hd;
                12'd628: toneR = `hd;   12'd629: toneR = `hd;
                12'd630: toneR = `hd;   12'd631: toneR = `hd;
                12'd632: toneR = `hc;   12'd633: toneR = `hc;
                12'd634: toneR = `hc;   12'd635: toneR = `hc;
                12'd636: toneR = `hc;   12'd637: toneR = `hc;
                12'd638: toneR = `hc;   12'd639: toneR = `hc;

                // --- Measure 11 ---
                12'd640: toneR = `hb;   12'd641: toneR = `hb;
                12'd642: toneR = `hb;   12'd643: toneR = `hb;
                12'd644: toneR = `hb;   12'd645: toneR = `hb;
                12'd646: toneR = `hb;   12'd647: toneR = `hb;
                12'd648: toneR = `hb;   12'd649: toneR = `hb;
                12'd650: toneR = `hb;   12'd651: toneR = `hb;
                12'd652: toneR = `hb;   12'd653: toneR = `hb;
                12'd654: toneR = `hb;   12'd655: toneR = `sil;

                12'd656: toneR = `hb;   12'd657: toneR = `hb;
                12'd658: toneR = `hb;   12'd659: toneR = `hb;
                12'd660: toneR = `hb;   12'd661: toneR = `hb;
                12'd662: toneR = `hb;   12'd663: toneR = `hb;
                12'd664: toneR = `hc;   12'd665: toneR = `hc;
                12'd666: toneR = `hc;   12'd667: toneR = `hc;
                12'd668: toneR = `hc;   12'd669: toneR = `hc;
                12'd670: toneR = `hc;   12'd671: toneR = `hc;

                12'd672: toneR = `hd;   12'd673: toneR = `hd;
                12'd674: toneR = `hd;   12'd675: toneR = `hd;
                12'd676: toneR = `hd;   12'd677: toneR = `hd;
                12'd678: toneR = `hd;   12'd679: toneR = `hd;
                12'd680: toneR = `hd;   12'd681: toneR = `hd;
                12'd682: toneR = `hd;   12'd683: toneR = `hd;
                12'd684: toneR = `hd;   12'd685: toneR = `hd;
                12'd686: toneR = `hd;   12'd687: toneR = `hd;

                12'd688: toneR = `he;   12'd689: toneR = `he;
                12'd690: toneR = `he;   12'd691: toneR = `he;
                12'd692: toneR = `he;   12'd693: toneR = `he;
                12'd694: toneR = `he;   12'd695: toneR = `he;
                12'd696: toneR = `he;   12'd697: toneR = `he;
                12'd698: toneR = `he;   12'd699: toneR = `he;
                12'd700: toneR = `he;   12'd701: toneR = `he;
                12'd702: toneR = `he;   12'd703: toneR = `he;

                // --- Measure 12 ---
                12'd704: toneR = `hc;   12'd705: toneR = `hc;
                12'd706: toneR = `hc;   12'd707: toneR = `hc;
                12'd708: toneR = `hc;   12'd709: toneR = `hc;
                12'd710: toneR = `hc;   12'd711: toneR = `hc;
                12'd712: toneR = `hc;   12'd713: toneR = `hc;
                12'd714: toneR = `hc;   12'd715: toneR = `hc;
                12'd716: toneR = `hc;   12'd717: toneR = `hc;
                12'd718: toneR = `hc;   12'd719: toneR = `hc;

                12'd720: toneR = `ha;   12'd721: toneR = `ha;
                12'd722: toneR = `ha;   12'd723: toneR = `ha;
                12'd724: toneR = `ha;   12'd725: toneR = `ha;
                12'd726: toneR = `ha;   12'd727: toneR = `ha;
                12'd728: toneR = `ha;   12'd729: toneR = `ha;
                12'd730: toneR = `ha;   12'd731: toneR = `ha;
                12'd732: toneR = `ha;   12'd733: toneR = `ha;
                12'd734: toneR = `ha;   12'd735: toneR = `sil;

                12'd736: toneR = `ha;   12'd737: toneR = `ha;
                12'd738: toneR = `ha;   12'd739: toneR = `ha;
                12'd740: toneR = `ha;   12'd741: toneR = `ha;
                12'd742: toneR = `ha;   12'd743: toneR = `ha;
                12'd744: toneR = `ha;   12'd745: toneR = `ha;
                12'd746: toneR = `ha;   12'd747: toneR = `ha;
                12'd748: toneR = `ha;   12'd749: toneR = `ha;
                12'd750: toneR = `ha;   12'd751: toneR = `ha;

                12'd752: toneR = `ha;   12'd753: toneR = `ha;
                12'd754: toneR = `ha;   12'd755: toneR = `ha;
                12'd756: toneR = `ha;   12'd757: toneR = `ha;
                12'd758: toneR = `ha;   12'd759: toneR = `ha;
                12'd760: toneR = `ha;   12'd761: toneR = `ha;
                12'd762: toneR = `ha;   12'd763: toneR = `ha;
                12'd764: toneR = `ha;   12'd765: toneR = `ha;
                12'd766: toneR = `ha;   12'd767: toneR = `ha;

                // --- Measure 13 ---
                12'd768: toneR = `hd;   12'd769: toneR = `hd;
                12'd770: toneR = `hd;   12'd771: toneR = `hd;
                12'd772: toneR = `hd;   12'd773: toneR = `hd;
                12'd774: toneR = `hd;   12'd775: toneR = `hd;
                12'd776: toneR = `hd;   12'd777: toneR = `hd;
                12'd778: toneR = `hd;   12'd779: toneR = `hd;
                12'd780: toneR = `hd;   12'd781: toneR = `hd;
                12'd782: toneR = `hd;   12'd783: toneR = `sil;

                12'd784: toneR = `hd;   12'd785: toneR = `hd;
                12'd786: toneR = `hd;   12'd787: toneR = `hd;
                12'd788: toneR = `hd;   12'd789: toneR = `hd;
                12'd790: toneR = `hd;   12'd791: toneR = `hd;
                12'd792: toneR = `hf;   12'd793: toneR = `hf;
                12'd794: toneR = `hf;   12'd795: toneR = `hf;
                12'd796: toneR = `hf;   12'd797: toneR = `hf;
                12'd798: toneR = `hf;   12'd799: toneR = `hf;

                12'd800: toneR = `hha;   12'd801: toneR = `hha;
                12'd802: toneR = `hha;   12'd803: toneR = `hha;
                12'd804: toneR = `hha;   12'd805: toneR = `hha;
                12'd806: toneR = `hha;   12'd807: toneR = `hha;
                12'd808: toneR = `hha;   12'd809: toneR = `hha;
                12'd810: toneR = `hha;   12'd811: toneR = `hha;
                12'd812: toneR = `hha;   12'd813: toneR = `hha;
                12'd814: toneR = `hha;   12'd815: toneR = `hha;

                12'd816: toneR = `hg;   12'd817: toneR = `hg;
                12'd818: toneR = `hg;   12'd819: toneR = `hg;
                12'd820: toneR = `hg;   12'd821: toneR = `hg;
                12'd822: toneR = `hg;   12'd823: toneR = `hg;
                12'd824: toneR = `hf;   12'd825: toneR = `hf;
                12'd826: toneR = `hf;   12'd827: toneR = `hf;
                12'd828: toneR = `hf;   12'd829: toneR = `hf;
                12'd830: toneR = `hf;   12'd831: toneR = `hf;

                // --- Measure 14 ---
                12'd832: toneR = `he;   12'd833: toneR = `he;
                12'd834: toneR = `he;   12'd835: toneR = `he;
                12'd836: toneR = `he;   12'd837: toneR = `he;
                12'd838: toneR = `he;   12'd839: toneR = `he;
                12'd840: toneR = `he;   12'd841: toneR = `he;
                12'd842: toneR = `he;   12'd843: toneR = `he;
                12'd844: toneR = `he;   12'd845: toneR = `he;
                12'd846: toneR = `he;   12'd847: toneR = `sil;

                12'd848: toneR = `he;   12'd849: toneR = `he;
                12'd850: toneR = `he;   12'd851: toneR = `he;
                12'd852: toneR = `he;   12'd853: toneR = `he;
                12'd854: toneR = `he;   12'd855: toneR = `he;
                12'd856: toneR = `hc;   12'd857: toneR = `hc;
                12'd858: toneR = `hc;   12'd859: toneR = `hc;
                12'd860: toneR = `hc;   12'd861: toneR = `hc;
                12'd862: toneR = `hc;   12'd863: toneR = `hc;

                12'd864: toneR = `he;   12'd865: toneR = `he;
                12'd866: toneR = `he;   12'd867: toneR = `he;
                12'd868: toneR = `he;   12'd869: toneR = `he;
                12'd870: toneR = `he;   12'd871: toneR = `he;
                12'd872: toneR = `he;   12'd873: toneR = `he;
                12'd874: toneR = `he;   12'd875: toneR = `he;
                12'd876: toneR = `he;   12'd877: toneR = `he;
                12'd878: toneR = `he;   12'd879: toneR = `he;

                12'd880: toneR = `hd;   12'd881: toneR = `hd;
                12'd882: toneR = `hd;   12'd883: toneR = `hd;
                12'd884: toneR = `hd;   12'd885: toneR = `hd;
                12'd886: toneR = `hd;   12'd887: toneR = `hd;
                12'd888: toneR = `hc;   12'd889: toneR = `hc;
                12'd890: toneR = `hc;   12'd891: toneR = `hc;
                12'd892: toneR = `hc;   12'd893: toneR = `hc;
                12'd894: toneR = `hc;   12'd895: toneR = `hc;

                // --- Measure 15 ---
                12'd896: toneR = `hb;   12'd897: toneR = `hb;
                12'd898: toneR = `hb;   12'd899: toneR = `hb;
                12'd900: toneR = `hb;   12'd901: toneR = `hb;
                12'd902: toneR = `hb;   12'd903: toneR = `hb;
                12'd904: toneR = `hb;   12'd905: toneR = `hb;
                12'd906: toneR = `hb;   12'd907: toneR = `hb;
                12'd908: toneR = `hb;   12'd909: toneR = `hb;
                12'd910: toneR = `hb;   12'd911: toneR = `sil;

                12'd912: toneR = `hb;   12'd913: toneR = `hb;
                12'd914: toneR = `hb;   12'd915: toneR = `hb;
                12'd916: toneR = `hb;   12'd917: toneR = `hb;
                12'd918: toneR = `hb;   12'd919: toneR = `hb;
                12'd920: toneR = `hc;   12'd921: toneR = `hc;
                12'd922: toneR = `hc;   12'd923: toneR = `hc;
                12'd924: toneR = `hc;   12'd925: toneR = `hc;
                12'd926: toneR = `hc;   12'd927: toneR = `hc;

                12'd928: toneR = `hd;   12'd929: toneR = `hd;
                12'd930: toneR = `hd;   12'd931: toneR = `hd;
                12'd932: toneR = `hd;   12'd933: toneR = `hd;
                12'd934: toneR = `hd;   12'd935: toneR = `hd;
                12'd936: toneR = `hd;   12'd937: toneR = `hd;
                12'd938: toneR = `hd;   12'd939: toneR = `hd;
                12'd940: toneR = `hd;   12'd941: toneR = `hd;
                12'd942: toneR = `hd;   12'd943: toneR = `hd;

                12'd944: toneR = `he;   12'd945: toneR = `he;
                12'd946: toneR = `he;   12'd947: toneR = `he;
                12'd948: toneR = `he;   12'd949: toneR = `he;
                12'd950: toneR = `he;   12'd951: toneR = `he;
                12'd952: toneR = `he;   12'd953: toneR = `he;
                12'd954: toneR = `he;   12'd955: toneR = `he;
                12'd956: toneR = `he;   12'd957: toneR = `he;
                12'd958: toneR = `he;   12'd959: toneR = `he;

                // --- Measure 16 ---
                12'd960: toneR = `hc;   12'd961: toneR = `hc;
                12'd962: toneR = `hc;   12'd963: toneR = `hc;
                12'd964: toneR = `hc;   12'd965: toneR = `hc;
                12'd966: toneR = `hc;   12'd967: toneR = `hc;
                12'd968: toneR = `hc;   12'd969: toneR = `hc;
                12'd970: toneR = `hc;   12'd971: toneR = `hc;
                12'd972: toneR = `hc;   12'd973: toneR = `hc;
                12'd974: toneR = `hc;   12'd975: toneR = `hc;

                12'd976: toneR = `ha;   12'd977: toneR = `ha;
                12'd978: toneR = `ha;   12'd979: toneR = `ha;
                12'd980: toneR = `ha;   12'd981: toneR = `ha;
                12'd982: toneR = `ha;   12'd983: toneR = `ha;
                12'd984: toneR = `ha;   12'd985: toneR = `ha;
                12'd986: toneR = `ha;   12'd987: toneR = `ha;
                12'd988: toneR = `ha;   12'd989: toneR = `ha;
                12'd990: toneR = `ha;   12'd991: toneR = `sil;

                12'd992: toneR = `ha;   12'd993: toneR = `ha;
                12'd994: toneR = `ha;   12'd995: toneR = `ha;
                12'd996: toneR = `ha;   12'd997: toneR = `ha;
                12'd998: toneR = `ha;   12'd999: toneR = `ha;
                12'd1000: toneR = `ha;   12'd1001: toneR = `ha;
                12'd1002: toneR = `ha;   12'd1003: toneR = `ha;
                12'd1004: toneR = `ha;   12'd1005: toneR = `ha;
                12'd1006: toneR = `ha;   12'd1007: toneR = `ha;

                12'd1008: toneR = `ha;   12'd1009: toneR = `ha;
                12'd1010: toneR = `ha;   12'd1011: toneR = `ha;
                12'd1012: toneR = `ha;   12'd1013: toneR = `ha;
                12'd1014: toneR = `ha;   12'd1015: toneR = `ha;
                12'd1016: toneR = `ha;   12'd1017: toneR = `ha;
                12'd1018: toneR = `ha;   12'd1019: toneR = `ha;
                12'd1020: toneR = `ha;   12'd1021: toneR = `ha;
                12'd1022: toneR = `ha;   12'd1023: toneR = `ha;
                default: toneR = `sil;
            endcase
        */
        end else begin
            toneR = `sil;
        end
    end

    always @(*) begin
        if(state == `INI)begin
            toneL = `sil;
        /*
            case(ibeatNum)
                // Measure 1 ---
                12'd0: toneL = `le;   12'd1: toneL = `le;
                12'd2: toneL = `le;   12'd3: toneL = `le;
                12'd4: toneL = `le;   12'd5: toneL = `le;
                12'd6: toneL = `le;   12'd7: toneL = `le;
                12'd8: toneL = `e;   12'd9: toneL = `e;
                12'd10: toneL = `e;   12'd11: toneL = `e;
                12'd12: toneL = `e;   12'd13: toneL = `e;
                12'd14: toneL = `e;   12'd15: toneL = `e;

                12'd16: toneL = `le;   12'd17: toneL = `le;
                12'd18: toneL = `le;   12'd19: toneL = `le;
                12'd20: toneL = `le;   12'd21: toneL = `le;
                12'd22: toneL = `le;   12'd23: toneL = `le;
                12'd24: toneL = `e;   12'd25: toneL = `e;
                12'd26: toneL = `e;   12'd27: toneL = `e;
                12'd28: toneL = `e;   12'd29: toneL = `e;
                12'd30: toneL = `e;   12'd31: toneL = `e;

                12'd32: toneL = `le;   12'd33: toneL = `le;
                12'd34: toneL = `le;   12'd35: toneL = `le;
                12'd36: toneL = `le;   12'd37: toneL = `le;
                12'd38: toneL = `le;   12'd39: toneL = `le;
                12'd40: toneL = `e;   12'd41: toneL = `e;
                12'd42: toneL = `e;   12'd43: toneL = `e;
                12'd44: toneL = `e;   12'd45: toneL = `e;
                12'd46: toneL = `e;   12'd47: toneL = `e;

                12'd48: toneL = `le;   12'd49: toneL = `le;
                12'd50: toneL = `le;   12'd51: toneL = `le;
                12'd52: toneL = `le;   12'd53: toneL = `le;
                12'd54: toneL = `le;   12'd55: toneL = `le;
                12'd56: toneL = `e;   12'd57: toneL = `e;
                12'd58: toneL = `e;   12'd59: toneL = `e;
                12'd60: toneL = `e;   12'd61: toneL = `e;
                12'd62: toneL = `e;   12'd63: toneL = `e;

                // Measure 2 ---
                12'd64: toneL = `lla;   12'd65: toneL = `lla;
                12'd66: toneL = `lla;   12'd67: toneL = `lla;
                12'd68: toneL = `lla;   12'd69: toneL = `lla;
                12'd70: toneL = `lla;   12'd71: toneL = `lla;
                12'd72: toneL = `la;   12'd73: toneL = `la;
                12'd74: toneL = `la;   12'd75: toneL = `la;
                12'd76: toneL = `la;   12'd77: toneL = `la;
                12'd78: toneL = `la;   12'd79: toneL = `la;

                12'd80: toneL = `lla;   12'd81: toneL = `lla;
                12'd82: toneL = `lla;   12'd83: toneL = `lla;
                12'd84: toneL = `lla;   12'd85: toneL = `lla;
                12'd86: toneL = `lla;   12'd87: toneL = `lla;
                12'd88: toneL = `la;   12'd89: toneL = `la;
                12'd90: toneL = `la;   12'd91: toneL = `la;
                12'd92: toneL = `la;   12'd93: toneL = `la;
                12'd94: toneL = `la;   12'd95: toneL = `la;

                12'd96: toneL = `lla;   12'd97: toneL = `lla;
                12'd98: toneL = `lla;   12'd99: toneL = `lla;
                12'd100: toneL = `lla;   12'd101: toneL = `lla;
                12'd102: toneL = `lla;   12'd103: toneL = `lla;
                12'd104: toneL = `la;   12'd105: toneL = `la;
                12'd106: toneL = `la;   12'd107: toneL = `la;
                12'd108: toneL = `la;   12'd109: toneL = `la;
                12'd110: toneL = `la;   12'd111: toneL = `la;

                12'd112: toneL = `lla;   12'd113: toneL = `lla;
                12'd114: toneL = `lla;   12'd115: toneL = `lla;
                12'd116: toneL = `lla;   12'd117: toneL = `lla;
                12'd118: toneL = `lla;   12'd119: toneL = `lla;
                12'd120: toneL = `la;   12'd121: toneL = `la;
                12'd122: toneL = `la;   12'd123: toneL = `la;
                12'd124: toneL = `la;   12'd125: toneL = `la;
                12'd126: toneL = `la;   12'd127: toneL = `la;

                // Measure 3 ---
                12'd128: toneL = `lg;   12'd129: toneL = `lg;
                12'd130: toneL = `lg;   12'd131: toneL = `lg;
                12'd132: toneL = `lg;   12'd133: toneL = `lg;
                12'd134: toneL = `lg;   12'd135: toneL = `lg;
                12'd136: toneL = `g;   12'd137: toneL = `g;
                12'd138: toneL = `g;   12'd139: toneL = `g;
                12'd140: toneL = `g;   12'd141: toneL = `g;
                12'd142: toneL = `g;   12'd143: toneL = `g;

                12'd144: toneL = `lg;   12'd145: toneL = `lg;
                12'd146: toneL = `lg;   12'd147: toneL = `lg;
                12'd148: toneL = `lg;   12'd149: toneL = `lg;
                12'd150: toneL = `lg;   12'd151: toneL = `lg;
                12'd152: toneL = `g;   12'd153: toneL = `g;
                12'd154: toneL = `g;   12'd155: toneL = `g;
                12'd156: toneL = `g;   12'd157: toneL = `g;
                12'd158: toneL = `g;   12'd159: toneL = `g;

                12'd160: toneL = `le;   12'd161: toneL = `le;
                12'd162: toneL = `le;   12'd163: toneL = `le;
                12'd164: toneL = `le;   12'd165: toneL = `le;
                12'd166: toneL = `le;   12'd167: toneL = `le;
                12'd168: toneL = `e;   12'd169: toneL = `e;
                12'd170: toneL = `e;   12'd171: toneL = `e;
                12'd172: toneL = `e;   12'd173: toneL = `e;
                12'd174: toneL = `e;   12'd175: toneL = `e;

                12'd176: toneL = `le;   12'd177: toneL = `le;
                12'd178: toneL = `le;   12'd179: toneL = `le;
                12'd180: toneL = `le;   12'd181: toneL = `le;
                12'd182: toneL = `le;   12'd183: toneL = `le;
                12'd184: toneL = `e;   12'd185: toneL = `e;
                12'd186: toneL = `e;   12'd187: toneL = `e;
                12'd188: toneL = `e;   12'd189: toneL = `e;
                12'd190: toneL = `e;   12'd191: toneL = `e;

                // Measure 4 ---
                12'd192: toneL = `lla;   12'd193: toneL = `lla;
                12'd194: toneL = `lla;   12'd195: toneL = `lla;
                12'd196: toneL = `lla;   12'd197: toneL = `lla;
                12'd198: toneL = `lla;   12'd199: toneL = `lla;
                12'd200: toneL = `la;   12'd201: toneL = `la;
                12'd202: toneL = `la;   12'd203: toneL = `la;
                12'd204: toneL = `la;   12'd205: toneL = `la;
                12'd206: toneL = `la;   12'd207: toneL = `la;

                12'd208: toneL = `lla;   12'd209: toneL = `lla;
                12'd210: toneL = `lla;   12'd211: toneL = `lla;
                12'd212: toneL = `lla;   12'd213: toneL = `lla;
                12'd214: toneL = `lla;   12'd215: toneL = `lla;
                12'd216: toneL = `la;   12'd217: toneL = `la;
                12'd218: toneL = `la;   12'd219: toneL = `la;
                12'd220: toneL = `la;   12'd221: toneL = `la;
                12'd222: toneL = `la;   12'd223: toneL = `la;

                12'd224: toneL = `lla;   12'd225: toneL = `lla;
                12'd226: toneL = `lla;   12'd227: toneL = `lla;
                12'd228: toneL = `lla;   12'd229: toneL = `lla;
                12'd230: toneL = `lla;   12'd231: toneL = `lla;
                12'd232: toneL = `lb;   12'd233: toneL = `lb;
                12'd234: toneL = `lb;   12'd235: toneL = `lb;
                12'd236: toneL = `lb;   12'd237: toneL = `lb;
                12'd238: toneL = `lb;   12'd239: toneL = `lb;

                12'd240: toneL = `c;   12'd241: toneL = `c;
                12'd242: toneL = `c;   12'd243: toneL = `c;
                12'd244: toneL = `c;   12'd245: toneL = `c;
                12'd246: toneL = `c;   12'd247: toneL = `c;
                12'd248: toneL = `d;   12'd249: toneL = `d;
                12'd250: toneL = `d;   12'd251: toneL = `d;
                12'd252: toneL = `d;   12'd253: toneL = `d;
                12'd254: toneL = `d;   12'd255: toneL = `d;

                // Measure 5 ---
                12'd256: toneL = `ld;   12'd257: toneL = `ld;
                12'd258: toneL = `ld;   12'd259: toneL = `ld;
                12'd260: toneL = `ld;   12'd261: toneL = `ld;
                12'd262: toneL = `ld;   12'd263: toneL = `ld;
                12'd264: toneL = `d;   12'd265: toneL = `d;
                12'd266: toneL = `d;   12'd267: toneL = `d;
                12'd268: toneL = `d;   12'd269: toneL = `d;
                12'd270: toneL = `d;   12'd271: toneL = `d;

                12'd272: toneL = `ld;   12'd273: toneL = `ld;
                12'd274: toneL = `ld;   12'd275: toneL = `ld;
                12'd276: toneL = `ld;   12'd277: toneL = `ld;
                12'd278: toneL = `ld;   12'd279: toneL = `ld;
                12'd280: toneL = `d;   12'd281: toneL = `d;
                12'd282: toneL = `d;   12'd283: toneL = `d;
                12'd284: toneL = `d;   12'd285: toneL = `d;
                12'd286: toneL = `d;   12'd287: toneL = `d;

                12'd288: toneL = `ld;   12'd289: toneL = `ld;
                12'd290: toneL = `ld;   12'd291: toneL = `ld;
                12'd292: toneL = `ld;   12'd293: toneL = `ld;
                12'd294: toneL = `ld;   12'd295: toneL = `ld;
                12'd296: toneL = `d;   12'd297: toneL = `d;
                12'd298: toneL = `d;   12'd299: toneL = `d;
                12'd300: toneL = `d;   12'd301: toneL = `d;
                12'd302: toneL = `d;   12'd303: toneL = `d;

                12'd304: toneL = `ld;   12'd305: toneL = `ld;
                12'd306: toneL = `ld;   12'd307: toneL = `ld;
                12'd308: toneL = `ld;   12'd309: toneL = `ld;
                12'd310: toneL = `ld;   12'd311: toneL = `ld;
                12'd312: toneL = `d;   12'd313: toneL = `d;
                12'd314: toneL = `d;   12'd315: toneL = `d;
                12'd316: toneL = `d;   12'd317: toneL = `d;
                12'd318: toneL = `d;   12'd319: toneL = `d;

                // Measure 6 ---
                12'd320: toneL = `lc;   12'd321: toneL = `lc;
                12'd322: toneL = `lc;   12'd323: toneL = `lc;
                12'd324: toneL = `lc;   12'd325: toneL = `lc;
                12'd326: toneL = `lc;   12'd327: toneL = `lc;
                12'd328: toneL = `c;   12'd329: toneL = `c;
                12'd330: toneL = `c;   12'd331: toneL = `c;
                12'd332: toneL = `c;   12'd333: toneL = `c;
                12'd334: toneL = `c;   12'd335: toneL = `c;

                12'd336: toneL = `lc;   12'd337: toneL = `lc;
                12'd338: toneL = `lc;   12'd339: toneL = `lc;
                12'd340: toneL = `lc;   12'd341: toneL = `lc;
                12'd342: toneL = `lc;   12'd343: toneL = `lc;
                12'd344: toneL = `c;   12'd345: toneL = `c;
                12'd346: toneL = `c;   12'd347: toneL = `c;
                12'd348: toneL = `c;   12'd349: toneL = `c;
                12'd350: toneL = `c;   12'd351: toneL = `c;

                12'd352: toneL = `lc;   12'd353: toneL = `lc;
                12'd354: toneL = `lc;   12'd355: toneL = `lc;
                12'd356: toneL = `lc;   12'd357: toneL = `lc;
                12'd358: toneL = `lc;   12'd359: toneL = `lc;
                12'd360: toneL = `c;   12'd361: toneL = `c;
                12'd362: toneL = `c;   12'd363: toneL = `c;
                12'd364: toneL = `c;   12'd365: toneL = `c;
                12'd366: toneL = `c;   12'd367: toneL = `c;

                12'd368: toneL = `lc;   12'd369: toneL = `lc;
                12'd370: toneL = `lc;   12'd371: toneL = `lc;
                12'd372: toneL = `lc;   12'd373: toneL = `lc;
                12'd374: toneL = `lc;   12'd375: toneL = `lc;
                12'd376: toneL = `c;   12'd377: toneL = `c;
                12'd378: toneL = `c;   12'd379: toneL = `c;
                12'd380: toneL = `c;   12'd381: toneL = `c;
                12'd382: toneL = `c;   12'd383: toneL = `c;

                // Measure 7 ---
                12'd384: toneL = `llg;   12'd385: toneL = `llg;
                12'd386: toneL = `llg;   12'd387: toneL = `llg;
                12'd388: toneL = `llg;   12'd389: toneL = `llg;
                12'd390: toneL = `llg;   12'd391: toneL = `llg;
                12'd392: toneL = `lg;   12'd393: toneL = `lg;
                12'd394: toneL = `lg;   12'd395: toneL = `lg;
                12'd396: toneL = `lg;   12'd397: toneL = `lg;
                12'd398: toneL = `lg;   12'd399: toneL = `lg;

                12'd400: toneL = `llg;   12'd401: toneL = `llg;
                12'd402: toneL = `llg;   12'd403: toneL = `llg;
                12'd404: toneL = `llg;   12'd405: toneL = `llg;
                12'd406: toneL = `llg;   12'd407: toneL = `llg;
                12'd408: toneL = `lg;   12'd409: toneL = `lg;
                12'd410: toneL = `lg;   12'd411: toneL = `lg;
                12'd412: toneL = `lg;   12'd413: toneL = `lg;
                12'd414: toneL = `lg;   12'd415: toneL = `lg;

                12'd416: toneL = `le;   12'd417: toneL = `le;
                12'd418: toneL = `le;   12'd419: toneL = `le;
                12'd420: toneL = `le;   12'd421: toneL = `le;
                12'd422: toneL = `le;   12'd423: toneL = `le;
                12'd424: toneL = `e;   12'd425: toneL = `e;
                12'd426: toneL = `e;   12'd427: toneL = `e;
                12'd428: toneL = `e;   12'd429: toneL = `e;
                12'd430: toneL = `e;   12'd431: toneL = `e;

                12'd432: toneL = `le;   12'd433: toneL = `le;
                12'd434: toneL = `le;   12'd435: toneL = `le;
                12'd436: toneL = `le;   12'd437: toneL = `le;
                12'd438: toneL = `le;   12'd439: toneL = `le;
                12'd440: toneL = `e;   12'd441: toneL = `e;
                12'd442: toneL = `e;   12'd443: toneL = `e;
                12'd444: toneL = `e;   12'd445: toneL = `e;
                12'd446: toneL = `e;   12'd447: toneL = `e;

                // Measure 8 ---
                12'd448: toneL = `lla;   12'd449: toneL = `lla;
                12'd450: toneL = `lla;   12'd451: toneL = `lla;
                12'd452: toneL = `lla;   12'd453: toneL = `lla;
                12'd454: toneL = `lla;   12'd455: toneL = `lla;
                12'd456: toneL = `la;   12'd457: toneL = `la;
                12'd458: toneL = `la;   12'd459: toneL = `la;
                12'd460: toneL = `la;   12'd461: toneL = `la;
                12'd462: toneL = `la;   12'd463: toneL = `la;

                12'd464: toneL = `lla;   12'd465: toneL = `lla;
                12'd466: toneL = `lla;   12'd467: toneL = `lla;
                12'd468: toneL = `lla;   12'd469: toneL = `lla;
                12'd470: toneL = `lla;   12'd471: toneL = `lla;
                12'd472: toneL = `la;   12'd473: toneL = `la;
                12'd474: toneL = `la;   12'd475: toneL = `la;
                12'd476: toneL = `la;   12'd477: toneL = `la;
                12'd478: toneL = `la;   12'd479: toneL = `la;

                12'd480: toneL = `lla;   12'd481: toneL = `lla;
                12'd482: toneL = `lla;   12'd483: toneL = `lla;
                12'd484: toneL = `lla;   12'd485: toneL = `lla;
                12'd486: toneL = `lla;   12'd487: toneL = `lla;
                12'd488: toneL = `la;   12'd489: toneL = `la;
                12'd490: toneL = `la;   12'd491: toneL = `la;
                12'd492: toneL = `la;   12'd493: toneL = `la;
                12'd494: toneL = `la;   12'd495: toneL = `la;

                12'd496: toneL = `lla;   12'd497: toneL = `lla;
                12'd498: toneL = `lla;   12'd499: toneL = `lla;
                12'd500: toneL = `lla;   12'd501: toneL = `lla;
                12'd502: toneL = `lla;   12'd503: toneL = `lla;
                12'd504: toneL = `lla;   12'd505: toneL = `lla;
                12'd506: toneL = `lla;   12'd507: toneL = `lla;
                12'd508: toneL = `lla;   12'd509: toneL = `lla;
                12'd510: toneL = `lla;   12'd511: toneL = `lla;
                // Measure 9 ---
                12'd512: toneL = `le;   12'd513: toneL = `le;
                12'd514: toneL = `le;   12'd515: toneL = `le;
                12'd516: toneL = `le;   12'd517: toneL = `le;
                12'd518: toneL = `le;   12'd519: toneL = `le;
                12'd520: toneL = `e;   12'd521: toneL = `e;
                12'd522: toneL = `e;   12'd523: toneL = `e;
                12'd524: toneL = `e;   12'd525: toneL = `e;
                12'd526: toneL = `e;   12'd527: toneL = `e;

                12'd528: toneL = `le;   12'd529: toneL = `le;
                12'd530: toneL = `le;   12'd531: toneL = `le;
                12'd532: toneL = `le;   12'd533: toneL = `le;
                12'd534: toneL = `le;   12'd535: toneL = `le;
                12'd536: toneL = `e;   12'd537: toneL = `e;
                12'd538: toneL = `e;   12'd539: toneL = `e;
                12'd540: toneL = `e;   12'd541: toneL = `e;
                12'd542: toneL = `e;   12'd543: toneL = `e;

                12'd544: toneL = `le;   12'd545: toneL = `le;
                12'd546: toneL = `le;   12'd547: toneL = `le;
                12'd548: toneL = `le;   12'd549: toneL = `le;
                12'd550: toneL = `le;   12'd551: toneL = `le;
                12'd552: toneL = `e;   12'd553: toneL = `e;
                12'd554: toneL = `e;   12'd555: toneL = `e;
                12'd556: toneL = `e;   12'd557: toneL = `e;
                12'd558: toneL = `e;   12'd559: toneL = `e;

                12'd560: toneL = `le;   12'd561: toneL = `le;
                12'd562: toneL = `le;   12'd563: toneL = `le;
                12'd564: toneL = `le;   12'd565: toneL = `le;
                12'd566: toneL = `le;   12'd567: toneL = `le;
                12'd568: toneL = `e;   12'd569: toneL = `e;
                12'd570: toneL = `e;   12'd571: toneL = `e;
                12'd572: toneL = `e;   12'd573: toneL = `e;
                12'd574: toneL = `e;   12'd575: toneL = `e;

                // Measure 10 ---
                12'd576: toneL = `lla;   12'd577: toneL = `lla;
                12'd578: toneL = `lla;   12'd579: toneL = `lla;
                12'd580: toneL = `lla;   12'd581: toneL = `lla;
                12'd582: toneL = `lla;   12'd583: toneL = `lla;
                12'd584: toneL = `la;   12'd585: toneL = `la;
                12'd586: toneL = `la;   12'd587: toneL = `la;
                12'd588: toneL = `la;   12'd589: toneL = `la;
                12'd590: toneL = `la;   12'd591: toneL = `la;

                12'd592: toneL = `lla;   12'd593: toneL = `lla;
                12'd594: toneL = `lla;   12'd595: toneL = `lla;
                12'd596: toneL = `lla;   12'd597: toneL = `lla;
                12'd598: toneL = `lla;   12'd599: toneL = `lla;
                12'd600: toneL = `la;   12'd601: toneL = `la;
                12'd602: toneL = `la;   12'd603: toneL = `la;
                12'd604: toneL = `la;   12'd605: toneL = `la;
                12'd606: toneL = `la;   12'd607: toneL = `la;

                12'd608: toneL = `lla;   12'd609: toneL = `lla;
                12'd610: toneL = `lla;   12'd611: toneL = `lla;
                12'd612: toneL = `lla;   12'd613: toneL = `lla;
                12'd614: toneL = `lla;   12'd615: toneL = `lla;
                12'd616: toneL = `la;   12'd617: toneL = `la;
                12'd618: toneL = `la;   12'd619: toneL = `la;
                12'd620: toneL = `la;   12'd621: toneL = `la;
                12'd622: toneL = `la;   12'd623: toneL = `la;

                12'd624: toneL = `lla;   12'd625: toneL = `lla;
                12'd626: toneL = `lla;   12'd627: toneL = `lla;
                12'd628: toneL = `lla;   12'd629: toneL = `lla;
                12'd630: toneL = `lla;   12'd631: toneL = `lla;
                12'd632: toneL = `la;   12'd633: toneL = `la;
                12'd634: toneL = `la;   12'd635: toneL = `la;
                12'd636: toneL = `la;   12'd637: toneL = `la;
                12'd638: toneL = `la;   12'd639: toneL = `la;

                // Measure 11 ---
                12'd640: toneL = `lg;   12'd641: toneL = `lg;
                12'd642: toneL = `lg;   12'd643: toneL = `lg;
                12'd644: toneL = `lg;   12'd645: toneL = `lg;
                12'd646: toneL = `lg;   12'd647: toneL = `lg;
                12'd648: toneL = `g;   12'd649: toneL = `g;
                12'd650: toneL = `g;   12'd651: toneL = `g;
                12'd652: toneL = `g;   12'd653: toneL = `g;
                12'd654: toneL = `g;   12'd655: toneL = `g;

                12'd656: toneL = `lg;   12'd657: toneL = `lg;
                12'd658: toneL = `lg;   12'd659: toneL = `lg;
                12'd660: toneL = `lg;   12'd661: toneL = `lg;
                12'd662: toneL = `lg;   12'd663: toneL = `lg;
                12'd664: toneL = `g;   12'd665: toneL = `g;
                12'd666: toneL = `g;   12'd667: toneL = `g;
                12'd668: toneL = `g;   12'd669: toneL = `g;
                12'd670: toneL = `g;   12'd671: toneL = `g;

                12'd672: toneL = `le;   12'd673: toneL = `le;
                12'd674: toneL = `le;   12'd675: toneL = `le;
                12'd676: toneL = `le;   12'd677: toneL = `le;
                12'd678: toneL = `le;   12'd679: toneL = `le;
                12'd680: toneL = `e;   12'd681: toneL = `e;
                12'd682: toneL = `e;   12'd683: toneL = `e;
                12'd684: toneL = `e;   12'd685: toneL = `e;
                12'd686: toneL = `e;   12'd687: toneL = `e;

                12'd688: toneL = `le;   12'd689: toneL = `le;
                12'd690: toneL = `le;   12'd691: toneL = `le;
                12'd692: toneL = `le;   12'd693: toneL = `le;
                12'd694: toneL = `le;   12'd695: toneL = `le;
                12'd696: toneL = `e;   12'd697: toneL = `e;
                12'd698: toneL = `e;   12'd699: toneL = `e;
                12'd700: toneL = `e;   12'd701: toneL = `e;
                12'd702: toneL = `e;   12'd703: toneL = `e;

                // Measure 12 ---
                12'd704: toneL = `lla;   12'd705: toneL = `lla;
                12'd706: toneL = `lla;   12'd707: toneL = `lla;
                12'd708: toneL = `lla;   12'd709: toneL = `lla;
                12'd710: toneL = `lla;   12'd711: toneL = `lla;
                12'd712: toneL = `la;   12'd713: toneL = `la;
                12'd714: toneL = `la;   12'd715: toneL = `la;
                12'd716: toneL = `la;   12'd717: toneL = `la;
                12'd718: toneL = `la;   12'd719: toneL = `la;

                12'd720: toneL = `lla;   12'd721: toneL = `lla;
                12'd722: toneL = `lla;   12'd723: toneL = `lla;
                12'd724: toneL = `lla;   12'd725: toneL = `lla;
                12'd726: toneL = `lla;   12'd727: toneL = `lla;
                12'd728: toneL = `la;   12'd729: toneL = `la;
                12'd730: toneL = `la;   12'd731: toneL = `la;
                12'd732: toneL = `la;   12'd733: toneL = `la;
                12'd734: toneL = `la;   12'd735: toneL = `la;

                12'd736: toneL = `lla;   12'd737: toneL = `lla;
                12'd738: toneL = `lla;   12'd739: toneL = `lla;
                12'd740: toneL = `lla;   12'd741: toneL = `lla;
                12'd742: toneL = `lla;   12'd743: toneL = `lla;
                12'd744: toneL = `lb;   12'd745: toneL = `lb;
                12'd746: toneL = `lb;   12'd747: toneL = `lb;
                12'd748: toneL = `lb;   12'd749: toneL = `lb;
                12'd750: toneL = `lb;   12'd751: toneL = `lb;

                12'd752: toneL = `c;   12'd753: toneL = `c;
                12'd754: toneL = `c;   12'd755: toneL = `c;
                12'd756: toneL = `c;   12'd757: toneL = `c;
                12'd758: toneL = `c;   12'd759: toneL = `c;
                12'd760: toneL = `d;   12'd761: toneL = `d;
                12'd762: toneL = `d;   12'd763: toneL = `d;
                12'd764: toneL = `d;   12'd765: toneL = `d;
                12'd766: toneL = `d;   12'd767: toneL = `d;

                // Measure 13 ---
                12'd768: toneL = `le;   12'd769: toneL = `le;
                12'd770: toneL = `le;   12'd771: toneL = `le;
                12'd772: toneL = `le;   12'd773: toneL = `le;
                12'd774: toneL = `le;   12'd775: toneL = `le;
                12'd776: toneL = `e;   12'd777: toneL = `e;
                12'd778: toneL = `e;   12'd779: toneL = `e;
                12'd780: toneL = `e;   12'd781: toneL = `e;
                12'd782: toneL = `e;   12'd783: toneL = `e;

                12'd784: toneL = `le;   12'd785: toneL = `le;
                12'd786: toneL = `le;   12'd787: toneL = `le;
                12'd788: toneL = `le;   12'd789: toneL = `le;
                12'd790: toneL = `le;   12'd791: toneL = `le;
                12'd792: toneL = `e;   12'd793: toneL = `e;
                12'd794: toneL = `e;   12'd795: toneL = `e;
                12'd796: toneL = `e;   12'd797: toneL = `e;
                12'd798: toneL = `e;   12'd799: toneL = `e;

                12'd800: toneL = `le;   12'd801: toneL = `le;
                12'd802: toneL = `le;   12'd803: toneL = `le;
                12'd804: toneL = `le;   12'd805: toneL = `le;
                12'd806: toneL = `le;   12'd807: toneL = `le;
                12'd808: toneL = `e;   12'd809: toneL = `e;
                12'd810: toneL = `e;   12'd811: toneL = `e;
                12'd812: toneL = `e;   12'd813: toneL = `e;
                12'd814: toneL = `e;   12'd815: toneL = `e;

                12'd816: toneL = `le;   12'd817: toneL = `le;
                12'd818: toneL = `le;   12'd819: toneL = `le;
                12'd820: toneL = `le;   12'd821: toneL = `le;
                12'd822: toneL = `le;   12'd823: toneL = `le;
                12'd824: toneL = `e;   12'd825: toneL = `e;
                12'd826: toneL = `e;   12'd827: toneL = `e;
                12'd828: toneL = `e;   12'd829: toneL = `e;
                12'd830: toneL = `e;   12'd831: toneL = `e;

                // Measure 14 ---
                12'd832: toneL = `lc;   12'd833: toneL = `lc;
                12'd834: toneL = `lc;   12'd835: toneL = `lc;
                12'd836: toneL = `lc;   12'd837: toneL = `lc;
                12'd838: toneL = `lc;   12'd839: toneL = `lc;
                12'd840: toneL = `c;   12'd841: toneL = `c;
                12'd842: toneL = `c;   12'd843: toneL = `c;
                12'd844: toneL = `c;   12'd845: toneL = `c;
                12'd846: toneL = `c;   12'd847: toneL = `c;

                12'd848: toneL = `lc;   12'd849: toneL = `lc;
                12'd850: toneL = `lc;   12'd851: toneL = `lc;
                12'd852: toneL = `lc;   12'd853: toneL = `lc;
                12'd854: toneL = `lc;   12'd855: toneL = `lc;
                12'd856: toneL = `c;   12'd857: toneL = `c;
                12'd858: toneL = `c;   12'd859: toneL = `c;
                12'd860: toneL = `c;   12'd861: toneL = `c;
                12'd862: toneL = `c;   12'd863: toneL = `c;

                12'd864: toneL = `lc;   12'd865: toneL = `lc;
                12'd866: toneL = `lc;   12'd867: toneL = `lc;
                12'd868: toneL = `lc;   12'd869: toneL = `lc;
                12'd870: toneL = `lc;   12'd871: toneL = `lc;
                12'd872: toneL = `c;   12'd873: toneL = `c;
                12'd874: toneL = `c;   12'd875: toneL = `c;
                12'd876: toneL = `c;   12'd877: toneL = `c;
                12'd878: toneL = `c;   12'd879: toneL = `c;

                12'd880: toneL = `lc;   12'd881: toneL = `lc;
                12'd882: toneL = `lc;   12'd883: toneL = `lc;
                12'd884: toneL = `lc;   12'd885: toneL = `lc;
                12'd886: toneL = `lc;   12'd887: toneL = `lc;
                12'd888: toneL = `c;   12'd889: toneL = `c;
                12'd890: toneL = `c;   12'd891: toneL = `c;
                12'd892: toneL = `c;   12'd893: toneL = `c;
                12'd894: toneL = `c;   12'd895: toneL = `c;
                
                // Measure 15 ---
                12'd896: toneL = `llg;   12'd897: toneL = `llg;
                12'd898: toneL = `llg;   12'd899: toneL = `llg;
                12'd900: toneL = `llg;   12'd901: toneL = `llg;
                12'd902: toneL = `llg;   12'd903: toneL = `llg;
                12'd904: toneL = `lg;   12'd905: toneL = `lg;
                12'd906: toneL = `lg;   12'd907: toneL = `lg;
                12'd908: toneL = `lg;   12'd909: toneL = `lg;
                12'd910: toneL = `lg;   12'd911: toneL = `lg;

                12'd912: toneL = `llg;   12'd913: toneL = `llg;
                12'd914: toneL = `llg;   12'd915: toneL = `llg;
                12'd916: toneL = `llg;   12'd917: toneL = `llg;
                12'd918: toneL = `llg;   12'd919: toneL = `llg;
                12'd920: toneL = `lg;   12'd921: toneL = `lg;
                12'd922: toneL = `lg;   12'd923: toneL = `lg;
                12'd924: toneL = `lg;   12'd925: toneL = `lg;
                12'd926: toneL = `lg;   12'd927: toneL = `lg;

                12'd928: toneL = `le;   12'd929: toneL = `le;
                12'd930: toneL = `le;   12'd931: toneL = `le;
                12'd932: toneL = `le;   12'd933: toneL = `le;
                12'd934: toneL = `le;   12'd935: toneL = `le;
                12'd936: toneL = `e;   12'd937: toneL = `e;
                12'd938: toneL = `e;   12'd939: toneL = `e;
                12'd940: toneL = `e;   12'd941: toneL = `e;
                12'd942: toneL = `e;   12'd943: toneL = `e;

                12'd944: toneL = `le;   12'd945: toneL = `le;
                12'd946: toneL = `le;   12'd947: toneL = `le;
                12'd948: toneL = `le;   12'd949: toneL = `le;
                12'd950: toneL = `le;   12'd951: toneL = `le;
                12'd952: toneL = `e;   12'd953: toneL = `e;
                12'd954: toneL = `e;   12'd955: toneL = `e;
                12'd956: toneL = `e;   12'd957: toneL = `e;
                12'd958: toneL = `e;   12'd959: toneL = `e;
                
                // Measure 16 ---
                12'd960: toneL = `lla;   12'd961: toneL = `lla;
                12'd962: toneL = `lla;   12'd963: toneL = `lla;
                12'd964: toneL = `lla;   12'd965: toneL = `lla;
                12'd966: toneL = `lla;   12'd967: toneL = `lla;
                12'd968: toneL = `la;   12'd969: toneL = `la;
                12'd970: toneL = `la;   12'd971: toneL = `la;
                12'd972: toneL = `la;   12'd973: toneL = `la;
                12'd974: toneL = `la;   12'd975: toneL = `la;

                12'd976: toneL = `lla;   12'd977: toneL = `lla;
                12'd978: toneL = `lla;   12'd979: toneL = `lla;
                12'd980: toneL = `lla;   12'd981: toneL = `lla;
                12'd982: toneL = `lla;   12'd983: toneL = `lla;
                12'd984: toneL = `la;   12'd985: toneL = `la;
                12'd986: toneL = `la;   12'd987: toneL = `la;
                12'd988: toneL = `la;   12'd989: toneL = `la;
                12'd990: toneL = `la;   12'd991: toneL = `la;

                12'd992: toneL = `lla;   12'd993: toneL = `lla;
                12'd994: toneL = `lla;   12'd995: toneL = `lla;
                12'd996: toneL = `lla;   12'd997: toneL = `lla;
                12'd998: toneL = `lla;   12'd999: toneL = `lla;
                12'd1000: toneL = `la;   12'd1001: toneL = `la;
                12'd1002: toneL = `la;   12'd1003: toneL = `la;
                12'd1004: toneL = `la;   12'd1005: toneL = `la;
                12'd1006: toneL = `la;   12'd1007: toneL = `la;

                12'd1008: toneL = `lla;   12'd1009: toneL = `lla;
                12'd1010: toneL = `lla;   12'd1011: toneL = `lla;
                12'd1012: toneL = `lla;   12'd1013: toneL = `lla;
                12'd1014: toneL = `lla;   12'd1015: toneL = `lla;
                12'd1016: toneL = `lla;   12'd1017: toneL = `lla;
                12'd1018: toneL = `lla;   12'd1019: toneL = `lla;
                12'd1020: toneL = `lla;   12'd1021: toneL = `lla;
                12'd1022: toneL = `lla;   12'd1023: toneL = `lla;
                default : toneL = `sil;
            endcase
        */
        end
        else begin
            toneL = `sil;
        end
    end

    //second song
    always @* begin
        if(state != `INI) begin
        
            case(ibeatNum)
                // --- Measure 1 ---
                12'd0: _toneR = `hc;   12'd1: _toneR = `hc;
                12'd2: _toneR = `hc;   12'd3: _toneR = `hc;
                12'd4: _toneR = `hc;   12'd5: _toneR = `hc;
                12'd6: _toneR = `hc;   12'd7: _toneR = `hc;
                12'd8: _toneR = `hc;   12'd9: _toneR = `hc;
                12'd10: _toneR = `hc;   12'd11: _toneR = `hc;
                12'd12: _toneR = `hc;  12'd13: _toneR = `hc;
                12'd14: _toneR = `hc;  12'd15: _toneR = `sil; // (Short break for repetitive notes: high E)

                12'd16: _toneR = `hd;   12'd17: _toneR = `hd;
                12'd18: _toneR = `hd;   12'd19: _toneR = `hd;
                12'd20: _toneR = `hd;   12'd21: _toneR = `hd;
                12'd22: _toneR = `hd;   12'd23: _toneR = `hd;
                12'd24: _toneR = `hd;   12'd25: _toneR = `hd;
                12'd26: _toneR = `hd;   12'd27: _toneR = `hd;
                12'd28: _toneR = `hd;   12'd29: _toneR = `hd;
                12'd30: _toneR = `hd;   12'd31: _toneR = `sil;

                12'd32: _toneR = `he;   12'd33: _toneR = `he;
                12'd34: _toneR = `he;   12'd35: _toneR = `he;
                12'd36: _toneR = `he;   12'd37: _toneR = `he;
                12'd38: _toneR = `he;   12'd39: _toneR = `he;
                12'd40: _toneR = `he;   12'd41: _toneR = `he;
                12'd42: _toneR = `he;   12'd43: _toneR = `he;
                12'd44: _toneR = `he;   12'd45: _toneR = `he;
                12'd46: _toneR = `he;   12'd47: _toneR = `sil; // (Short break for repetitive notes: high D)

                12'd48: _toneR = `hc;   12'd49: _toneR = `hc;
                12'd50: _toneR = `hc;   12'd51: _toneR = `hc;
                12'd52: _toneR = `hc;   12'd53: _toneR = `hc;
                12'd54: _toneR = `hc;   12'd55: _toneR = `hc;
                12'd56: _toneR = `hc;   12'd57: _toneR = `hc;
                12'd58: _toneR = `hc;   12'd59: _toneR = `hc;
                12'd60: _toneR = `hc;   12'd61: _toneR = `hc;
                12'd62: _toneR = `hc;   12'd63: _toneR = `sil;

                // --- Measure 2 ---
                12'd64: _toneR = `hc;   12'd65: _toneR = `hc;
                12'd66: _toneR = `hc;   12'd67: _toneR = `hc;
                12'd68: _toneR = `hc;   12'd69: _toneR = `hc;
                12'd70: _toneR = `hc;   12'd71: _toneR = `hc;
                12'd72: _toneR = `hc;   12'd73: _toneR = `hc;
                12'd74: _toneR = `hc;   12'd75: _toneR = `hc;
                12'd76: _toneR = `hc;   12'd77: _toneR = `hc;
                12'd78: _toneR = `hc;   12'd79: _toneR = `sil;

                12'd80: _toneR = `hd;   12'd81: _toneR = `hd;
                12'd82: _toneR = `hd;   12'd83: _toneR = `hd;
                12'd84: _toneR = `hd;   12'd85: _toneR = `hd;
                12'd86: _toneR = `hd;   12'd87: _toneR = `hd;
                12'd88: _toneR = `hd;   12'd89: _toneR = `hd;
                12'd90: _toneR = `hd;   12'd91: _toneR = `hd;
                12'd92: _toneR = `hd;   12'd93: _toneR = `hd;
                12'd94: _toneR = `hd;   12'd95: _toneR = `sil;

                12'd96: _toneR = `he;   12'd97: _toneR = `he;
                12'd98: _toneR = `he;   12'd99: _toneR = `he;
                12'd100: _toneR = `he;   12'd101: _toneR = `he;
                12'd102: _toneR = `he;   12'd103: _toneR = `he;
                12'd104: _toneR = `he;   12'd105: _toneR = `he;
                12'd106: _toneR = `he;   12'd107: _toneR = `he;
                12'd108: _toneR = `he;   12'd109: _toneR = `he;
                12'd110: _toneR = `he;   12'd111: _toneR = `sil; // (Short break for repetitive notes: high D)

                12'd112: _toneR = `hc;   12'd113: _toneR = `hc;
                12'd114: _toneR = `hc;   12'd115: _toneR = `hc;
                12'd116: _toneR = `hc;   12'd117: _toneR = `hc;
                12'd118: _toneR = `hc;   12'd119: _toneR = `hc;
                12'd120: _toneR = `hc;   12'd121: _toneR = `hc;
                12'd122: _toneR = `hc;   12'd123: _toneR = `hc;
                12'd124: _toneR = `hc;   12'd125: _toneR = `hc;
                12'd126: _toneR = `hc;   12'd127: _toneR = `sil;

                // --- Measure 3 ---
                12'd128: _toneR = `he;   12'd129: _toneR = `he;
                12'd130: _toneR = `he;   12'd131: _toneR = `he;
                12'd132: _toneR = `he;   12'd133: _toneR = `he;
                12'd134: _toneR = `he;   12'd135: _toneR = `he;
                12'd136: _toneR = `he;   12'd137: _toneR = `he;
                12'd138: _toneR = `he;   12'd139: _toneR = `he;
                12'd140: _toneR = `he;   12'd141: _toneR = `he;
                12'd142: _toneR = `he;   12'd143: _toneR = `sil;

                12'd144: _toneR = `hf;   12'd145: _toneR = `hf;
                12'd146: _toneR = `hf;   12'd147: _toneR = `hf;
                12'd148: _toneR = `hf;   12'd149: _toneR = `hf;
                12'd150: _toneR = `hf;   12'd151: _toneR = `hf;
                12'd152: _toneR = `hf;   12'd153: _toneR = `hf;
                12'd154: _toneR = `hf;   12'd155: _toneR = `hf;
                12'd156: _toneR = `hf;   12'd157: _toneR = `hf;
                12'd158: _toneR = `hf;   12'd159: _toneR = `hf;

                12'd160: _toneR = `hg;   12'd161: _toneR = `hg;
                12'd162: _toneR = `hg;   12'd163: _toneR = `hg;
                12'd164: _toneR = `hg;   12'd165: _toneR = `hg;
                12'd166: _toneR = `hg;   12'd167: _toneR = `hg;
                12'd168: _toneR = `hg;   12'd169: _toneR = `hg;
                12'd170: _toneR = `hg;   12'd171: _toneR = `hg;
                12'd172: _toneR = `hg;   12'd173: _toneR = `hg;
                12'd174: _toneR = `hg;   12'd175: _toneR = `hg;

                12'd176: _toneR = `hg;   12'd177: _toneR = `hg;
                12'd178: _toneR = `hg;   12'd179: _toneR = `hg;
                12'd180: _toneR = `hg;   12'd181: _toneR = `hg;
                12'd182: _toneR = `hg;   12'd183: _toneR = `hg;
                12'd184: _toneR = `hg;   12'd185: _toneR = `hg;
                12'd186: _toneR = `hg;   12'd187: _toneR = `hg;
                12'd188: _toneR = `hg;   12'd189: _toneR = `hg;
                12'd190: _toneR = `hg;   12'd191: _toneR = `sil;

                // --- Measure 4 ---
                12'd192: _toneR = `he;   12'd193: _toneR = `he;
                12'd194: _toneR = `he;   12'd195: _toneR = `he;
                12'd196: _toneR = `he;   12'd197: _toneR = `he;
                12'd198: _toneR = `he;   12'd199: _toneR = `he;
                12'd200: _toneR = `he;   12'd201: _toneR = `he;
                12'd202: _toneR = `he;   12'd203: _toneR = `he;
                12'd204: _toneR = `he;   12'd205: _toneR = `he;
                12'd206: _toneR = `he;   12'd207: _toneR = `sil;

                12'd208: _toneR = `hf;   12'd209: _toneR = `hf;
                12'd210: _toneR = `hf;   12'd211: _toneR = `hf;
                12'd212: _toneR = `hf;   12'd213: _toneR = `hf;
                12'd214: _toneR = `hf;   12'd215: _toneR = `hf;
                12'd216: _toneR = `hf;   12'd217: _toneR = `hf;
                12'd218: _toneR = `hf;   12'd219: _toneR = `hf;
                12'd220: _toneR = `hf;   12'd221: _toneR = `hf;
                12'd222: _toneR = `hf;   12'd223: _toneR = `sil;

                12'd224: _toneR = `hg;   12'd225: _toneR = `hg;
                12'd226: _toneR = `hg;   12'd227: _toneR = `hg;
                12'd228: _toneR = `hg;   12'd229: _toneR = `hg;
                12'd230: _toneR = `hg;   12'd231: _toneR = `hg;
                12'd232: _toneR = `hg;   12'd233: _toneR = `hg;
                12'd234: _toneR = `hg;   12'd235: _toneR = `hg;
                12'd236: _toneR = `hg;   12'd237: _toneR = `hg;
                12'd238: _toneR = `hg;   12'd239: _toneR = `hg;

                12'd240: _toneR = `hg;   12'd241: _toneR = `hg;
                12'd242: _toneR = `hg;   12'd243: _toneR = `hg;
                12'd244: _toneR = `hg;   12'd245: _toneR = `hg;
                12'd246: _toneR = `hg;   12'd247: _toneR = `hg;
                12'd248: _toneR = `hg;   12'd249: _toneR = `hg;
                12'd250: _toneR = `hg;   12'd251: _toneR = `hg;
                12'd252: _toneR = `hg;   12'd253: _toneR = `hg;
                12'd254: _toneR = `hg;   12'd255: _toneR = `sil;

                // --- Measure 5 ---
                12'd256: _toneR = `hg;   12'd257: _toneR = `hg;
                12'd258: _toneR = `hg;   12'd259: _toneR = `hg;
                12'd260: _toneR = `hg;   12'd261: _toneR = `hg;
                12'd262: _toneR = `hg;   12'd263: _toneR = `hg;
                12'd264: _toneR = `ha;   12'd265: _toneR = `ha;
                12'd266: _toneR = `ha;   12'd267: _toneR = `ha;
                12'd268: _toneR = `ha;   12'd269: _toneR = `ha;
                12'd270: _toneR = `ha;   12'd271: _toneR = `ha;

                12'd272: _toneR = `hg;   12'd273: _toneR = `hg;
                12'd274: _toneR = `hg;   12'd275: _toneR = `hg;
                12'd276: _toneR = `hg;   12'd277: _toneR = `hg;
                12'd278: _toneR = `hg;   12'd279: _toneR = `hg;
                12'd280: _toneR = `hf;   12'd281: _toneR = `hf;
                12'd282: _toneR = `hf;   12'd283: _toneR = `hf;
                12'd284: _toneR = `hf;   12'd285: _toneR = `hf;
                12'd286: _toneR = `hf;   12'd287: _toneR = `sil;

                12'd288: _toneR = `he;   12'd289: _toneR = `he;
                12'd290: _toneR = `he;   12'd291: _toneR = `he;
                12'd292: _toneR = `he;   12'd293: _toneR = `he;
                12'd294: _toneR = `he;   12'd295: _toneR = `he;
                12'd296: _toneR = `he;   12'd297: _toneR = `he;
                12'd298: _toneR = `he;   12'd299: _toneR = `he;
                12'd300: _toneR = `he;   12'd301: _toneR = `he;
                12'd302: _toneR = `he;   12'd303: _toneR = `sil;

                12'd304: _toneR = `hc;   12'd305: _toneR = `hc;
                12'd306: _toneR = `hc;   12'd307: _toneR = `hc;
                12'd308: _toneR = `hc;   12'd309: _toneR = `hc;
                12'd310: _toneR = `hc;   12'd311: _toneR = `hc;
                12'd312: _toneR = `hc;   12'd313: _toneR = `hc;
                12'd314: _toneR = `hc;   12'd315: _toneR = `hc;
                12'd316: _toneR = `hc;   12'd317: _toneR = `hc;
                12'd318: _toneR = `hc;   12'd319: _toneR = `sil;

                // --- Measure 6 ---
                12'd320: _toneR = `hg;   12'd321: _toneR = `hg;
                12'd322: _toneR = `hg;   12'd323: _toneR = `hg;
                12'd324: _toneR = `hg;   12'd325: _toneR = `hg;
                12'd326: _toneR = `hg;   12'd327: _toneR = `hg;
                12'd328: _toneR = `ha;   12'd329: _toneR = `ha;
                12'd330: _toneR = `ha;   12'd331: _toneR = `ha;
                12'd332: _toneR = `ha;   12'd333: _toneR = `ha;
                12'd334: _toneR = `ha;   12'd335: _toneR = `ha;

                12'd336: _toneR = `hg;   12'd337: _toneR = `hg;
                12'd338: _toneR = `hg;   12'd339: _toneR = `hg;
                12'd340: _toneR = `hg;   12'd341: _toneR = `hg;
                12'd342: _toneR = `hg;   12'd343: _toneR = `hg;
                12'd344: _toneR = `hf;   12'd345: _toneR = `hf;
                12'd346: _toneR = `hf;   12'd347: _toneR = `hf;
                12'd348: _toneR = `hf;   12'd349: _toneR = `hf;
                12'd350: _toneR = `hf;   12'd351: _toneR = `hf;

                12'd352: _toneR = `he;   12'd353: _toneR = `he;
                12'd354: _toneR = `he;   12'd355: _toneR = `he;
                12'd356: _toneR = `he;   12'd357: _toneR = `he;
                12'd358: _toneR = `he;   12'd359: _toneR = `he;
                12'd360: _toneR = `he;   12'd361: _toneR = `he;
                12'd362: _toneR = `he;   12'd363: _toneR = `he;
                12'd364: _toneR = `he;   12'd365: _toneR = `he;
                12'd366: _toneR = `he;   12'd367: _toneR = `sil;

                12'd368: _toneR = `hc;   12'd369: _toneR = `hc;
                12'd370: _toneR = `hc;   12'd371: _toneR = `hc;
                12'd372: _toneR = `hc;   12'd373: _toneR = `hc;
                12'd374: _toneR = `hc;   12'd375: _toneR = `hc;
                12'd376: _toneR = `hc;   12'd377: _toneR = `hc;
                12'd378: _toneR = `hc;   12'd379: _toneR = `hc;
                12'd380: _toneR = `hc;   12'd381: _toneR = `hc;
                12'd382: _toneR = `hc;   12'd383: _toneR = `sil;

                // --- Measure 7 ---
                12'd384: _toneR = `hc;   12'd385: _toneR = `hc;
                12'd386: _toneR = `hc;   12'd387: _toneR = `hc;
                12'd388: _toneR = `hc;   12'd389: _toneR = `hc;
                12'd390: _toneR = `hc;   12'd391: _toneR = `hc;
                12'd392: _toneR = `hc;   12'd393: _toneR = `hc;
                12'd394: _toneR = `hc;   12'd395: _toneR = `hc;
                12'd396: _toneR = `hc;   12'd397: _toneR = `hc;
                12'd398: _toneR = `hc;   12'd399: _toneR = `sil;

                12'd400: _toneR = `g;   12'd401: _toneR = `g;
                12'd402: _toneR = `g;   12'd403: _toneR = `g;
                12'd404: _toneR = `g;   12'd405: _toneR = `g;
                12'd406: _toneR = `g;   12'd407: _toneR = `g;
                12'd408: _toneR = `g;   12'd409: _toneR = `g;
                12'd410: _toneR = `g;   12'd411: _toneR = `g;
                12'd412: _toneR = `g;   12'd413: _toneR = `g;
                12'd414: _toneR = `g;   12'd415: _toneR = `sil;

                12'd416: _toneR = `hc;   12'd417: _toneR = `hc;
                12'd418: _toneR = `hc;   12'd419: _toneR = `hc;
                12'd420: _toneR = `hc;   12'd421: _toneR = `hc;
                12'd422: _toneR = `hc;   12'd423: _toneR = `hc;
                12'd424: _toneR = `hc;   12'd425: _toneR = `hc;
                12'd426: _toneR = `hc;   12'd427: _toneR = `hc;
                12'd428: _toneR = `hc;   12'd429: _toneR = `hc;
                12'd430: _toneR = `hc;   12'd431: _toneR = `hc;

                12'd432: _toneR = `hc;   12'd433: _toneR = `hc;
                12'd434: _toneR = `hc;   12'd435: _toneR = `hc;
                12'd436: _toneR = `hc;   12'd437: _toneR = `hc;
                12'd438: _toneR = `hc;   12'd439: _toneR = `hc;
                12'd440: _toneR = `hc;   12'd441: _toneR = `hc;
                12'd442: _toneR = `hc;   12'd443: _toneR = `hc;
                12'd444: _toneR = `hc;   12'd445: _toneR = `hc;
                12'd446: _toneR = `hc;   12'd447: _toneR = `sil;

                // --- Measure 8 ---
                12'd448: _toneR = `hc;   12'd449: _toneR = `hc;
                12'd450: _toneR = `hc;   12'd451: _toneR = `hc;
                12'd452: _toneR = `hc;   12'd453: _toneR = `hc;
                12'd454: _toneR = `hc;   12'd455: _toneR = `hc;
                12'd456: _toneR = `hc;   12'd457: _toneR = `hc;
                12'd458: _toneR = `hc;   12'd459: _toneR = `hc;
                12'd460: _toneR = `hc;   12'd461: _toneR = `hc;
                12'd462: _toneR = `hc;   12'd463: _toneR = `sil;

                12'd464: _toneR = `g;   12'd465: _toneR = `g;
                12'd466: _toneR = `g;   12'd467: _toneR = `g;
                12'd468: _toneR = `g;   12'd469: _toneR = `g;
                12'd470: _toneR = `g;   12'd471: _toneR = `g;
                12'd472: _toneR = `g;   12'd473: _toneR = `g;
                12'd474: _toneR = `g;   12'd475: _toneR = `g;
                12'd476: _toneR = `g;   12'd477: _toneR = `g;
                12'd478: _toneR = `g;   12'd479: _toneR = `sil;

                12'd480: _toneR = `hc;   12'd481: _toneR = `hc;
                12'd482: _toneR = `hc;   12'd483: _toneR = `hc;
                12'd484: _toneR = `hc;   12'd485: _toneR = `hc;
                12'd486: _toneR = `hc;   12'd487: _toneR = `hc;
                12'd488: _toneR = `hc;   12'd489: _toneR = `hc;
                12'd490: _toneR = `hc;   12'd491: _toneR = `hc;
                12'd492: _toneR = `hc;   12'd493: _toneR = `hc;
                12'd494: _toneR = `hc;   12'd495: _toneR = `hc;

                12'd496: _toneR = `hc;   12'd497: _toneR = `hc;
                12'd498: _toneR = `hc;   12'd499: _toneR = `hc;
                12'd500: _toneR = `hc;   12'd501: _toneR = `hc;
                12'd502: _toneR = `hc;   12'd503: _toneR = `hc;
                12'd504: _toneR = `hc;   12'd505: _toneR = `hc;
                12'd506: _toneR = `hc;   12'd507: _toneR = `hc;
                12'd508: _toneR = `hc;   12'd509: _toneR = `hc;
                12'd510: _toneR = `hc;   12'd511: _toneR = `sil;
                default: _toneR = `sil;
            endcase
        
        end else begin
            _toneR = `sil;
        end
    end

    always @(*) begin
        if(state != `INI)begin
        
            case(ibeatNum)
                // --- Measure 1 ---
                12'd0: _toneL = `hc;   12'd1: _toneL = `hc;
                12'd2: _toneL = `hc;   12'd3: _toneL = `hc;
                12'd4: _toneL = `hc;   12'd5: _toneL = `hc;
                12'd6: _toneL = `hc;   12'd7: _toneL = `hc;
                12'd8: _toneL = `hc;   12'd9: _toneL = `hc;
                12'd10: _toneL = `hc;   12'd11: _toneL = `hc;
                12'd12: _toneL = `hc;   12'd13: _toneL = `hc;
                12'd14: _toneL = `hc;   12'd15: _toneL = `hc;

                12'd16: _toneL = `hc;   12'd17: _toneL = `hc;
                12'd18: _toneL = `hc;   12'd19: _toneL = `hc;
                12'd20: _toneL = `hc;   12'd21: _toneL = `hc;
                12'd22: _toneL = `hc;   12'd23: _toneL = `hc;
                12'd24: _toneL = `hc;   12'd25: _toneL = `hc;
                12'd26: _toneL = `hc;   12'd27: _toneL = `hc;
                12'd28: _toneL = `hc;   12'd29: _toneL = `hc;
                12'd30: _toneL = `hc;   12'd31: _toneL = `sil;

                12'd32: _toneL = `g;	12'd33: _toneL = `g; // G (one-beat)
                12'd34: _toneL = `g;	12'd35: _toneL = `g;
                12'd36: _toneL = `g;	12'd37: _toneL = `g;
                12'd38: _toneL = `g;	12'd39: _toneL = `g;
                12'd40: _toneL = `g;	12'd41: _toneL = `g;
                12'd42: _toneL = `g;	12'd43: _toneL = `g;
                12'd44: _toneL = `g;	12'd45: _toneL = `g;
                12'd46: _toneL = `g;	12'd47: _toneL = `g;

                12'd48: _toneL = `g;   12'd49: _toneL = `g;
                12'd50: _toneL = `g;   12'd51: _toneL = `g;
                12'd52: _toneL = `g;   12'd53: _toneL = `g;
                12'd54: _toneL = `g;   12'd55: _toneL = `g;
                12'd56: _toneL = `g;   12'd57: _toneL = `g;
                12'd58: _toneL = `g;   12'd59: _toneL = `g;
                12'd60: _toneL = `g;   12'd61: _toneL = `g;
                12'd62: _toneL = `g;   12'd63: _toneL = `sil;

                // --- Measure 2 ---
                12'd64: _toneL = `hc;	    12'd65: _toneL = `hc; // HC (two-beat)
                12'd66: _toneL = `hc;	    12'd67: _toneL = `hc;
                12'd68: _toneL = `hc;	    12'd69: _toneL = `hc;
                12'd70: _toneL = `hc;	    12'd71: _toneL = `hc;
                12'd72: _toneL = `hc;	    12'd73: _toneL = `hc;
                12'd74: _toneL = `hc;	    12'd75: _toneL = `hc;
                12'd76: _toneL = `hc;	    12'd77: _toneL = `hc;
                12'd78: _toneL = `hc;	    12'd79: _toneL = `hc;

                12'd80: _toneL = `hc;	    12'd81: _toneL = `hc;
                12'd82: _toneL = `hc;	    12'd83: _toneL = `hc;
                12'd84: _toneL = `hc;	    12'd85: _toneL = `hc;
                12'd86: _toneL = `hc;	    12'd87: _toneL = `hc;
                12'd88: _toneL = `hc;	    12'd89: _toneL = `hc;
                12'd90: _toneL = `hc;	    12'd91: _toneL = `hc;
                12'd92: _toneL = `hc;	    12'd93: _toneL = `hc;
                12'd94: _toneL = `hc;	    12'd95: _toneL = `sil;

                12'd96: _toneL = `g;	12'd97: _toneL = `g; // G (one-beat)
                12'd98: _toneL = `g; 	12'd99: _toneL = `g;
                12'd100: _toneL = `g;	12'd101: _toneL = `g;
                12'd102: _toneL = `g;	12'd103: _toneL = `g;
                12'd104: _toneL = `g;	12'd105: _toneL = `g;
                12'd106: _toneL = `g;	12'd107: _toneL = `g;
                12'd108: _toneL = `g;	12'd109: _toneL = `g;
                12'd110: _toneL = `g;	12'd111: _toneL = `g;

                12'd112: _toneL = `g;   12'd113: _toneL = `g;
                12'd114: _toneL = `g;   12'd115: _toneL = `g;
                12'd116: _toneL = `g;   12'd117: _toneL = `g;
                12'd118: _toneL = `g;   12'd119: _toneL = `g;
                12'd120: _toneL = `g;   12'd121: _toneL = `g;
                12'd122: _toneL = `g;   12'd123: _toneL = `g;
                12'd124: _toneL = `g;   12'd125: _toneL = `g;
                12'd126: _toneL = `g;   12'd127: _toneL = `sil;

                // --- Measure 3 ---
                12'd128: _toneL = `c;   12'd129: _toneL = `c;
                12'd130: _toneL = `c;   12'd131: _toneL = `c;
                12'd132: _toneL = `c;   12'd133: _toneL = `c;
                12'd134: _toneL = `c;   12'd135: _toneL = `c;
                12'd136: _toneL = `c;   12'd137: _toneL = `c;
                12'd138: _toneL = `c;   12'd139: _toneL = `c;
                12'd140: _toneL = `c;   12'd141: _toneL = `c;
                12'd142: _toneL = `c;   12'd143: _toneL = `sil;

                12'd144: _toneL = `d;   12'd145: _toneL = `d;
                12'd146: _toneL = `d;   12'd147: _toneL = `d;
                12'd148: _toneL = `d;   12'd149: _toneL = `d;
                12'd150: _toneL = `d;   12'd151: _toneL = `d;
                12'd152: _toneL = `d;   12'd153: _toneL = `d;
                12'd154: _toneL = `d;   12'd155: _toneL = `d;
                12'd156: _toneL = `d;   12'd157: _toneL = `d;
                12'd158: _toneL = `d;   12'd159: _toneL = `sil;

                12'd160: _toneL = `e;   12'd161: _toneL = `e;
                12'd162: _toneL = `e;   12'd163: _toneL = `e;
                12'd164: _toneL = `e;   12'd165: _toneL = `e;
                12'd166: _toneL = `e;   12'd167: _toneL = `e;
                12'd168: _toneL = `e;   12'd169: _toneL = `e;
                12'd170: _toneL = `e;   12'd171: _toneL = `e;
                12'd172: _toneL = `e;   12'd173: _toneL = `e;
                12'd174: _toneL = `e;   12'd175: _toneL = `e;

                12'd176: _toneL = `e;   12'd177: _toneL = `e;
                12'd178: _toneL = `e;   12'd179: _toneL = `e;
                12'd180: _toneL = `e;   12'd181: _toneL = `e;
                12'd182: _toneL = `e;   12'd183: _toneL = `e;
                12'd184: _toneL = `e;   12'd185: _toneL = `e;
                12'd186: _toneL = `e;   12'd187: _toneL = `e;
                12'd188: _toneL = `e;   12'd189: _toneL = `e;
                12'd190: _toneL = `e;   12'd191: _toneL = `sil;

                // --- Measure 4 ---
                12'd192: _toneL = `c;   12'd193: _toneL = `c;
                12'd194: _toneL = `c;   12'd195: _toneL = `c;
                12'd196: _toneL = `c;   12'd197: _toneL = `c;
                12'd198: _toneL = `c;   12'd199: _toneL = `c;
                12'd200: _toneL = `c;   12'd201: _toneL = `c;
                12'd202: _toneL = `c;   12'd203: _toneL = `c;
                12'd204: _toneL = `c;   12'd205: _toneL = `c;
                12'd206: _toneL = `c;   12'd207: _toneL = `sil;

                12'd208: _toneL = `d;   12'd209: _toneL = `d;
                12'd210: _toneL = `d;   12'd211: _toneL = `d;
                12'd212: _toneL = `d;   12'd213: _toneL = `d;
                12'd214: _toneL = `d;   12'd215: _toneL = `d;
                12'd216: _toneL = `d;   12'd217: _toneL = `d;
                12'd218: _toneL = `d;   12'd219: _toneL = `d;
                12'd220: _toneL = `d;   12'd221: _toneL = `d;
                12'd222: _toneL = `d;   12'd223: _toneL = `sil;

                12'd224: _toneL = `e;   12'd225: _toneL = `e;
                12'd226: _toneL = `e;   12'd227: _toneL = `e;
                12'd228: _toneL = `e;   12'd229: _toneL = `e;
                12'd230: _toneL = `e;   12'd231: _toneL = `e;
                12'd232: _toneL = `e;   12'd233: _toneL = `e;
                12'd234: _toneL = `e;   12'd235: _toneL = `e;
                12'd236: _toneL = `e;   12'd237: _toneL = `e;
                12'd238: _toneL = `e;   12'd239: _toneL = `e;

                12'd240: _toneL = `e;   12'd241: _toneL = `e;
                12'd242: _toneL = `e;   12'd243: _toneL = `e;
                12'd244: _toneL = `e;   12'd245: _toneL = `e;
                12'd246: _toneL = `e;   12'd247: _toneL = `e;
                12'd248: _toneL = `e;   12'd249: _toneL = `e;
                12'd250: _toneL = `e;   12'd251: _toneL = `e;
                12'd252: _toneL = `e;   12'd253: _toneL = `e;
                12'd254: _toneL = `e;   12'd255: _toneL = `sil;

                // --- Measure 5 ---
                12'd256: _toneL = `e;   12'd257: _toneL = `e;
                12'd258: _toneL = `e;   12'd259: _toneL = `e;
                12'd260: _toneL = `e;   12'd261: _toneL = `e;
                12'd262: _toneL = `e;   12'd263: _toneL = `e;
                12'd264: _toneL = `e;   12'd265: _toneL = `e;
                12'd266: _toneL = `e;   12'd267: _toneL = `e;
                12'd268: _toneL = `e;   12'd269: _toneL = `e;
                12'd270: _toneL = `e;   12'd271: _toneL = `sil;

                12'd272: _toneL = `f;   12'd273: _toneL = `f;
                12'd274: _toneL = `f;   12'd275: _toneL = `f;
                12'd276: _toneL = `f;   12'd277: _toneL = `f;
                12'd278: _toneL = `f;   12'd279: _toneL = `f;
                12'd280: _toneL = `f;   12'd281: _toneL = `f;
                12'd282: _toneL = `f;   12'd283: _toneL = `f;
                12'd284: _toneL = `f;   12'd285: _toneL = `f;
                12'd286: _toneL = `f;   12'd287: _toneL = `sil;

                12'd288: _toneL = `g;   12'd289: _toneL = `g;
                12'd290: _toneL = `g;   12'd291: _toneL = `g;
                12'd292: _toneL = `g;   12'd293: _toneL = `g;
                12'd294: _toneL = `g;   12'd295: _toneL = `g;
                12'd296: _toneL = `g;   12'd297: _toneL = `g;
                12'd298: _toneL = `g;   12'd299: _toneL = `g;
                12'd300: _toneL = `g;   12'd301: _toneL = `g;
                12'd302: _toneL = `g;   12'd303: _toneL = `g;

                12'd304: _toneL = `g;   12'd305: _toneL = `g;
                12'd306: _toneL = `g;   12'd307: _toneL = `g;
                12'd308: _toneL = `g;   12'd309: _toneL = `g;
                12'd310: _toneL = `g;   12'd311: _toneL = `g;
                12'd312: _toneL = `g;   12'd313: _toneL = `g;
                12'd314: _toneL = `g;   12'd315: _toneL = `g;
                12'd316: _toneL = `g;   12'd317: _toneL = `g;
                12'd318: _toneL = `g;   12'd319: _toneL = `sil;

                // --- Measure 6 ---
                12'd320: _toneL = `e;   12'd321: _toneL = `e;
                12'd322: _toneL = `e;   12'd323: _toneL = `e;
                12'd324: _toneL = `e;   12'd325: _toneL = `e;
                12'd326: _toneL = `e;   12'd327: _toneL = `e;
                12'd328: _toneL = `e;   12'd329: _toneL = `e;
                12'd330: _toneL = `e;   12'd331: _toneL = `e;
                12'd332: _toneL = `e;   12'd333: _toneL = `e;
                12'd334: _toneL = `e;   12'd335: _toneL = `sil;

                12'd336: _toneL = `f;   12'd337: _toneL = `f;
                12'd338: _toneL = `f;   12'd339: _toneL = `f;
                12'd340: _toneL = `f;   12'd341: _toneL = `f;
                12'd342: _toneL = `f;   12'd343: _toneL = `f;
                12'd344: _toneL = `f;   12'd345: _toneL = `f;
                12'd346: _toneL = `f;   12'd347: _toneL = `f;
                12'd348: _toneL = `f;   12'd349: _toneL = `f;
                12'd350: _toneL = `f;   12'd351: _toneL = `sil;

                12'd352: _toneL = `g;   12'd353: _toneL = `g;
                12'd354: _toneL = `g;   12'd355: _toneL = `g;
                12'd356: _toneL = `g;   12'd357: _toneL = `g;
                12'd358: _toneL = `g;   12'd359: _toneL = `g;
                12'd360: _toneL = `g;   12'd361: _toneL = `g;
                12'd362: _toneL = `g;   12'd363: _toneL = `g;
                12'd364: _toneL = `g;   12'd365: _toneL = `g;
                12'd366: _toneL = `g;   12'd367: _toneL = `g;

                12'd368: _toneL = `g;   12'd369: _toneL = `g;
                12'd370: _toneL = `g;   12'd371: _toneL = `g;
                12'd372: _toneL = `g;   12'd373: _toneL = `g;
                12'd374: _toneL = `g;   12'd375: _toneL = `g;
                12'd376: _toneL = `g;   12'd377: _toneL = `g;
                12'd378: _toneL = `g;   12'd379: _toneL = `g;
                12'd380: _toneL = `g;   12'd381: _toneL = `g;
                12'd382: _toneL = `g;   12'd383: _toneL = `sil;

                // --- Measure 7 ---
                12'd384: _toneL = `g;   12'd385: _toneL = `g;
                12'd386: _toneL = `g;   12'd387: _toneL = `g;
                12'd388: _toneL = `g;   12'd389: _toneL = `g;
                12'd390: _toneL = `g;   12'd391: _toneL = `g;
                12'd392: _toneL = `g;   12'd393: _toneL = `g;
                12'd394: _toneL = `g;   12'd395: _toneL = `g;
                12'd396: _toneL = `g;   12'd397: _toneL = `g;
                12'd398: _toneL = `g;   12'd399: _toneL = `g;

                12'd400: _toneL = `g;   12'd401: _toneL = `g;
                12'd402: _toneL = `g;   12'd403: _toneL = `g;
                12'd404: _toneL = `g;   12'd405: _toneL = `g;
                12'd406: _toneL = `g;   12'd407: _toneL = `g;
                12'd408: _toneL = `g;   12'd409: _toneL = `g;
                12'd410: _toneL = `g;   12'd411: _toneL = `g;
                12'd412: _toneL = `g;   12'd413: _toneL = `g;
                12'd414: _toneL = `g;   12'd415: _toneL = `sil;

                12'd416: _toneL = `e;   12'd417: _toneL = `e;
                12'd418: _toneL = `e;   12'd419: _toneL = `e;
                12'd420: _toneL = `e;   12'd421: _toneL = `e;
                12'd422: _toneL = `e;   12'd423: _toneL = `e;
                12'd424: _toneL = `e;   12'd425: _toneL = `e;
                12'd426: _toneL = `e;   12'd427: _toneL = `e;
                12'd428: _toneL = `e;   12'd429: _toneL = `e;
                12'd430: _toneL = `e;   12'd431: _toneL = `e;

                12'd432: _toneL = `e;   12'd433: _toneL = `e;
                12'd434: _toneL = `e;   12'd435: _toneL = `e;
                12'd436: _toneL = `e;   12'd437: _toneL = `e;
                12'd438: _toneL = `e;   12'd439: _toneL = `e;
                12'd440: _toneL = `e;   12'd441: _toneL = `e;
                12'd442: _toneL = `e;   12'd443: _toneL = `e;
                12'd444: _toneL = `e;   12'd445: _toneL = `e;
                12'd446: _toneL = `e;   12'd447: _toneL = `sil;

                // --- Measure 8 ---
                12'd448: _toneL = `g;   12'd449: _toneL = `g;
                12'd450: _toneL = `g;   12'd451: _toneL = `g;
                12'd452: _toneL = `g;   12'd453: _toneL = `g;
                12'd454: _toneL = `g;   12'd455: _toneL = `g;
                12'd456: _toneL = `g;   12'd457: _toneL = `g;
                12'd458: _toneL = `g;   12'd459: _toneL = `g;
                12'd460: _toneL = `g;   12'd461: _toneL = `g;
                12'd462: _toneL = `g;   12'd463: _toneL = `g;

                12'd464: _toneL = `g;   12'd465: _toneL = `g;
                12'd466: _toneL = `g;   12'd467: _toneL = `g;
                12'd468: _toneL = `g;   12'd469: _toneL = `g;
                12'd470: _toneL = `g;   12'd471: _toneL = `g;
                12'd472: _toneL = `g;   12'd473: _toneL = `g;
                12'd474: _toneL = `g;   12'd475: _toneL = `g;
                12'd476: _toneL = `g;   12'd477: _toneL = `g;
                12'd478: _toneL = `g;   12'd479: _toneL = `sil;

                12'd480: _toneL = `e;   12'd481: _toneL = `e;
                12'd482: _toneL = `e;   12'd483: _toneL = `e;
                12'd484: _toneL = `e;   12'd485: _toneL = `e;
                12'd486: _toneL = `e;   12'd487: _toneL = `e;
                12'd488: _toneL = `e;   12'd489: _toneL = `e;
                12'd490: _toneL = `e;   12'd491: _toneL = `e;
                12'd492: _toneL = `e;   12'd493: _toneL = `e;
                12'd494: _toneL = `e;   12'd495: _toneL = `e;

                12'd496: _toneL = `e;   12'd497: _toneL = `e;
                12'd498: _toneL = `e;   12'd499: _toneL = `e;
                12'd500: _toneL = `e;   12'd501: _toneL = `e;
                12'd502: _toneL = `e;   12'd503: _toneL = `e;
                12'd504: _toneL = `e;   12'd505: _toneL = `e;
                12'd506: _toneL = `e;   12'd507: _toneL = `e;
                12'd508: _toneL = `e;   12'd509: _toneL = `e;
                12'd510: _toneL = `e;   12'd511: _toneL = `e;
                default : _toneL = `sil;
            endcase
        
        end
        else begin
            _toneL = `sil;
        end
    end

endmodule

module speaker_control(
    clk,  // clock from the crystal
    rst,  // active high reset
    audio_in_left, // left channel audio data input
    audio_in_right, // right channel audio data input
    audio_mclk, // master clock
    audio_lrck, // left-right clock, Word Select clock, or sample rate clock
    audio_sck, // serial clock
    audio_sdin // serial audio data input
);

    // I/O declaration
    input clk;  // clock from the crystal
    input rst;  // active high reset
    input [15:0] audio_in_left; // left channel audio data input
    input [15:0] audio_in_right; // right channel audio data input
    output audio_mclk; // master clock
    output audio_lrck; // left-right clock
    output audio_sck; // serial clock
    output audio_sdin; // serial audio data input
    reg audio_sdin;

    // Declare internal signal nodes
    wire [8:0] clk_cnt_next;
    reg [8:0] clk_cnt;
    reg [15:0] audio_left, audio_right;

    // Counter for the clock divider
    assign clk_cnt_next = clk_cnt + 1'b1;

    always @(posedge clk or posedge rst)
        if (rst == 1'b1)
            clk_cnt <= 9'd0;
        else
            clk_cnt <= clk_cnt_next;

    // Assign divided clock output
    assign audio_mclk = clk_cnt[1];
    assign audio_lrck = clk_cnt[8];
    assign audio_sck = 1'b1; // use internal serial clock mode

    // audio input data buffer
    always @(posedge clk_cnt[8] or posedge rst)
        if (rst == 1'b1)
            begin
                audio_left <= 16'd0;
                audio_right <= 16'd0;
            end
        else
            begin
                audio_left <= audio_in_left;
                audio_right <= audio_in_right;
            end

    always @*
        case (clk_cnt[8:4])
            5'b00000: audio_sdin = audio_right[0];
            5'b00001: audio_sdin = audio_left[15];
            5'b00010: audio_sdin = audio_left[14];
            5'b00011: audio_sdin = audio_left[13];
            5'b00100: audio_sdin = audio_left[12];
            5'b00101: audio_sdin = audio_left[11];
            5'b00110: audio_sdin = audio_left[10];
            5'b00111: audio_sdin = audio_left[9];
            5'b01000: audio_sdin = audio_left[8];
            5'b01001: audio_sdin = audio_left[7];
            5'b01010: audio_sdin = audio_left[6];
            5'b01011: audio_sdin = audio_left[5];
            5'b01100: audio_sdin = audio_left[4];
            5'b01101: audio_sdin = audio_left[3];
            5'b01110: audio_sdin = audio_left[2];
            5'b01111: audio_sdin = audio_left[1];
            5'b10000: audio_sdin = audio_left[0];
            5'b10001: audio_sdin = audio_right[15];
            5'b10010: audio_sdin = audio_right[14];
            5'b10011: audio_sdin = audio_right[13];
            5'b10100: audio_sdin = audio_right[12];
            5'b10101: audio_sdin = audio_right[11];
            5'b10110: audio_sdin = audio_right[10];
            5'b10111: audio_sdin = audio_right[9];
            5'b11000: audio_sdin = audio_right[8];
            5'b11001: audio_sdin = audio_right[7];
            5'b11010: audio_sdin = audio_right[6];
            5'b11011: audio_sdin = audio_right[5];
            5'b11100: audio_sdin = audio_right[4];
            5'b11101: audio_sdin = audio_right[3];
            5'b11110: audio_sdin = audio_right[2];
            5'b11111: audio_sdin = audio_right[1];
            default: audio_sdin = 1'b0;
        endcase

endmodule

module music(
    input clk, // clock from crystal
    input rst, // active high reset: BTNC
    input _mute, // SW: Mute
    input _volUP, // BTN: Vol up
    input _volDOWN, // BTN: Vol down
    input [4:0] state,
    output audio_mclk, // master clock
    output audio_lrck, // left-right clock
    output audio_sck, // serial clock
    output audio_sdin // serial audio data input
);

    // Internal Signal
    wire [15:0] audio_in_left, audio_in_right;

    wire clkDiv22, play, clkDiv13, pb_volUP, pulse_volUP, pb_volDOWN, pulse_volDOWN, _en;
    wire [11:0] ibeatNum; // Beat counter
    wire [31:0] freqL, freqR, _freqL, _freqR; // Raw frequency, produced by music module
    wire [21:0] freq_outL, freq_outR; // Processed Frequency, adapted to the clock rate of Basys3

    reg [2:0] value, vol, next_vol;
    wire [2:0] _vol, note;

    debounce de_volUP(.pb_debounced(pb_volUP), .pb(_volUP), .clk(clkDiv13));
    OnePulse pul_volUP(.clock(clkDiv13), .signal(pb_volUP), .signal_single_pulse(pulse_volUP));

    debounce de_volDOWN(.pb_debounced(pb_volDOWN), .pb(_volDOWN), .clk(clkDiv13));
    OnePulse pul_volDOWN(.clock(clkDiv13), .signal(pb_volDOWN), .signal_single_pulse(pulse_volDOWN));

    always@(posedge clkDiv13) begin
        if(rst) begin
            vol <= 3'd3;
        end
        else begin
            vol <= next_vol;
        end
    end

    always@(*) begin
        if(pulse_volUP == 1'b1 && vol < 3'd5) begin
            next_vol = vol + 3'd1;
        end
        else if(pulse_volDOWN == 1'b1 && vol > 3'd1) begin
            next_vol = vol - 3'd1;
        end
        else begin
            next_vol = vol;
        end
    end

    assign _vol = vol;

    assign freq_outL = (state != `INI) ? 50000000 / (_mute ? `silence : freqL) : 50000000 / (_mute ? `silence : _freqL); // Note gen makes no sound, if freq_out = 50000000 / `silence = 1
    assign freq_outR = (state != `INI) ? 50000000 / (_mute ? `silence : freqR) : 50000000 / (_mute ? `silence : _freqR);

    clock_divider #(.n(22)) clock_22(
        .clk(clk),
        .clk_div(clkDiv22)
    );

    clock_divider #(.n(13)) clock_13(
        .clk(clk),
        .clk_div(clkDiv13)
    );

    // Player Control
    player_control playerCtrl_00 (
        .clk(clkDiv22),
        .reset(rst),
        .ibeat(ibeatNum),
        .music(state)
    );

    // Music module
    // [in]  beat number and en
    // [out] left & right raw frequency
    music_example music_00 (
        .ibeatNum(ibeatNum),
        .toneL(freqL),
        .toneR(freqR),
        ._toneL(_freqL),
        ._toneR(_freqR),
        .state(state)
    );

    // Note generation
    // [in]  processed frequency
    // [out] audio wave signal (using square wave here)
    note_gen noteGen_00(
        .clk(clk), // clock from crystal
        .rst(rst), // active high reset
        .note_div_left(freq_outL),
        .note_div_right(freq_outR),
        .audio_left(audio_in_left), // left sound audio
        .audio_right(audio_in_right),
        .volume(_vol) // 3 bits for 5 levels,
    );

    // Speaker controller
    speaker_control sc(
        .clk(clk),  // clock from the crystal
        .rst(rst),  // active high reset
        .audio_in_left(audio_in_left), // left channel audio data input
        .audio_in_right(audio_in_right), // right channel audio data input
        .audio_mclk(audio_mclk), // master clock
        .audio_lrck(audio_lrck), // left-right clock
        .audio_sck(audio_sck), // serial clock
        .audio_sdin(audio_sdin) // serial audio data input
    );

endmodule
