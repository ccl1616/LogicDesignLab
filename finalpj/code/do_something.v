module do_something (
    input clk,
    input rst,
    input rotate_hold,
    input force_down,
    input down,
    input right,
    input left,
    input [4:0] state,

    output [31:0] currentRotate,
    output [31:0] currentPiece,
    output signed [31:0] currentX,
    output signed [31:0] currentY,
    output [199:0] map,
    output [31:0] score,
    output [31:0] the_other_hard,
    output [199:0] pure_map
);
    reg [31:0] Rotate = 0;
    reg [31:0] Piece = 0;
    reg signed [31:0] PosX = 4;
    reg signed [31:0] PosY = 0; 
    reg [199:0] _map = 0;

    reg [31:0] next_Rotate;
    reg [31:0] next_Piece;
    reg signed [31:0] next_PosX;
    reg signed [31:0] next_PosY; 
    reg [31:0] Score = 0;
    wire [31:0] next_score;
    reg [199:0] next_map;
    wire [199:0] merge_map;
    wire [199:0] clear_line_drop_map;

    wire [31:0] rand;

    // key board add 
    wire X_plus_1_Y;
    wire X_minus_1_Y;
    wire X_Y_plus_1;
    wire X_Y_rotate;

    always @(posedge clk , posedge rst) begin
        if (rst) begin
            Rotate <= 0;
            Piece <= 0;
            PosX <= 4;
            PosY <= 0;
            _map <= 200'b0;
            Score <= 32'd0;
        end 
        else if (state == `INI) begin
            Rotate <= 0;
            Piece <= 0;
            PosX <= 4;
            PosY <= 0;
            _map <= 200'b0;
            Score <= 32'd0;
        end
        else begin
            Rotate <= next_Rotate;
            Piece <= next_Piece;
            PosX <= next_PosX;
            PosY <= next_PosY;
            _map <= next_map;
            if ((force_down == 1'b1) && (X_Y_plus_1 == 1'b0)) Score <= Score + next_score;
            else Score <= Score;
        end
    end

    //assign map = _map | now_drop_block;
    assign map = (_map | merge_map);
    assign pure_map = _map;
    assign currentRotate = Rotate;
    assign currentPiece = Piece;
    assign currentX = PosX;
    assign currentY = PosY;
    assign score = Score;
    assign the_other_hard = Score;



    always @(*) begin
        if (force_down) begin
            // can't down
            if (X_Y_plus_1 == 0) begin
                next_map = clear_line_drop_map;
                next_PosX = 4;
                next_PosY = 0;
                next_Rotate = 0;
                next_Piece = rand;
            end
            // can auto down
            // TYPE 1
            else begin
                next_map = _map;
                next_PosX = PosX + ((right & X_plus_1_Y) ? 1 : 0) - ((left & X_minus_1_Y) ? 1 : 0);
                next_PosY = PosY + 1 + ((down & X_Y_plus_1) ? 1 : 0);
                next_Rotate = Rotate + ((rotate_hold & X_Y_rotate) ? 1 : 0);
                next_Piece = Piece;
            end
        end 
        else begin
            // what ever move
            // TYPE 2
            next_map = _map;
            next_PosX = PosX + ((right & X_plus_1_Y) ? 1 : 0) - ((left & X_minus_1_Y) ? 1 : 0);
            next_PosY = PosY + ((down & X_Y_plus_1) ? 1 : 0);
            next_Rotate = Rotate + ((rotate_hold & X_Y_rotate) ? 1 : 0);
            next_Piece = Piece; 
        end
    end

    for_score _ssscore (
        .clk(clk),
        .rst(rst),
        .map(_map | merge_map),
        .delta_score(next_score)
    ); 

    random r (
        .clk(clk), 
        .rst(rst),
        .rand(rand)
    );
    clear_line_drop cldm (
        .clk(clk),
        .rst(rst),
        .now_map(_map | merge_map),
        .clear_line_drop_map(clear_line_drop_map)
    );
    gen_map type_1 (
        .clk(clk),
        .rst(rst),
        .currentRotate(Rotate),
        .currentPiece(Piece),
        .currentX(PosX),
        .currentY(PosY),
        .n_map(merge_map)
    );


    does_piece_fit a (
        .clk(clk),
        .rst(rst),
        .currentRotate(currentRotate),
        .currentPiece(currentPiece),
        .currentX(currentX + 1),
        .currentY(currentY),
        .map(_map),
        .fit(X_plus_1_Y)
    );
    does_piece_fit b (
        .clk(clk),
        .rst(rst),
        .currentRotate(currentRotate),
        .currentPiece(currentPiece),
        .currentX(currentX - 1),
        .currentY(currentY),
        .map(_map),
        .fit(X_minus_1_Y)
    );
    does_piece_fit c (
        .clk(clk),
        .rst(rst),
        .currentRotate(currentRotate),
        .currentPiece(currentPiece),
        .currentX(currentX),
        .currentY(currentY + 1),
        .map(_map),
        .fit(X_Y_plus_1)
    );
    does_piece_fit d (
        .clk(clk),
        .rst(rst),
        .currentRotate(currentRotate + 1),
        .currentPiece(currentPiece),
        .currentX(currentX),
        .currentY(currentY),
        .map(_map),
        .fit(X_Y_rotate)
    );



endmodule