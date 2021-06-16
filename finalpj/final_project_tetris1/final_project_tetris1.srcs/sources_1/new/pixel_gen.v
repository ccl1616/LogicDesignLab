module pixel_gen(
     input clk,
     input rst,
     input [9:0] v_cnt,
     input [9:0] h_cnt,
     input valid,
     input start,
     output reg [3:0] vgaRed,
     output reg [3:0] vgaGreen,
     output reg [3:0] vgaBlue,
     output init,
     output fall,
     output judge
     );

     /* state */
     parameter INIT = 2'd0;
     parameter FALL = 2'd1;
     parameter JUDGE = 2'd2;
     /* block */
     parameter I = 3'd0;
     /* ---- */
     parameter O = 3'd1;
     /* --
        -- */
     parameter T = 3'd2;
     /* ---
         - */
     parameter J = 3'd3;
     /* ---
          - */
     parameter L = 3'd4;
     /* ---
        - */
     parameter S = 3'd5;
     /* --
       -- */
     parameter _Z = 3'd6;
     /* --
         -- */

     wire clk_20;
     reg [1:0] state, next_state;
     reg [2:0] block, next_block, count, next_count;
     reg [4:0] pos, next_pos;
     reg [199:0] map, next_map;
     reg drop, next_drop;
     integer i, j, k, l;

     clock_divider #(.n(20)) div_20(.clk(clk), .clk_div(clk_20));

     always@(posedge clk_20 or posedge rst) begin
          if(rst) begin
               state <= INIT;
               count <= 3'b0;
               pos <= 5'd20;
               map <= 200'b0;
               drop <= 1'b0;
          end
          else begin
               state <= next_state;
               block <= next_block;
               count <= next_count;
               pos <= next_pos;
               map <= next_map;
               drop <= next_drop;
          end
     end

     always@(*) begin
          next_state = state;
          next_block = block;
          next_count = count;
          next_pos = pos;
          next_map = map;
          next_drop = drop;
          case(state)
               INIT: begin
                    next_count = count + 3'd1;
                    next_pos = 5'd20;
                    next_map = 200'b0;
                    next_drop = 1'b0;
                    if(start) begin
                         next_state = FALL;
                    end
                    if(!valid)
                         {vgaRed, vgaGreen, vgaBlue} = 12'h0;
                    else if(h_cnt < 200 || h_cnt > 440)
                         {vgaRed, vgaGreen, vgaBlue} = 12'h0ff;
                    else
                         {vgaRed, vgaGreen, vgaBlue} = 12'h0;
               end
               FALL: begin
                    next_pos = pos - 5'b1;
                    if(count % 7 == 0) begin
                         next_block = I;
                         next_map[6:3] = 4'b1111;
                    end
                    else if(count % 7 == 1) begin
                         next_block = O;
                         next_map[5:4] = 2'b11;
                         next_map[15:14] = 2'b11;
                    end
                    else if(count % 7 == 2) begin
                         next_block = T;
                         next_map[5:3] = 3'b111;
                         next_map[14] = 1'b1;
                    end
                    else if(count % 7 == 3) begin
                         next_block = J;
                         next_map[5:3] = 3'b111;
                         next_map[15] = 1'b1;
                    end
                    else if(count % 7 == 4) begin
                         next_block = L;
                         next_map[5:3] = 3'b111;
                         next_map[13] = 1'b1;
                    end
                    else if(count % 7 == 5) begin
                         next_block = S;
                         next_map[5:4] = 2'b11;
                         next_map[14:13] = 2'b11;
                    end
                    else begin
                         next_block = _Z;
                         next_map[4:3] = 2'b11;
                         next_map[15:14] = 2'b11;
                    end
                    case(block)
                         I: begin
                              for(i = 0;i < 190; i = i + 1) begin
                                   if(map[i] == 1'b1) begin
                                        next_map[i] = 1'b0;
                                        next_map[i + 10] = 1'b1;
                                   end
                              end
                              for(i = 3;i < 7;i = i + 1) begin
                                   if(map[10*pos + i] == 1'b1) begin
                                        next_state = JUDGE;
                                   end
                              end
                              if(pos == 5'b0) begin
                                   next_pos = 5'd20;
                              end
                         end
                         O: begin
                              for(i = 0;i < 190; i = i + 1) begin
                                   if(map[i] == 1'b1) begin
                                        next_map[i] = 1'b0;
                                        next_map[i + 10] = 1'b1;
                                   end
                              end
                              for(i = 4;i < 6;i = i + 1) begin
                                   if(map[10*pos + i] == 1'b1) begin
                                        next_state = JUDGE;
                                   end
                              end
                              if(pos == 5'b0) begin
                                   next_pos = 5'd20;
                              end
                         end
                         T: begin
                              for(i = 0;i < 190; i = i + 1) begin
                                   if(map[i] == 1'b1) begin
                                        next_map[i] = 1'b0;
                                        next_map[i + 10] = 1'b1;
                                   end
                              end
                              if(map[10*(pos + 1) + 4] == 1'b1) begin
                                   next_state = JUDGE;
                              end
                              else begin
                                   for(i = 3;i < 6;i = i + 1) begin
                                        if(map[10*pos + i] == 1'b1) begin
                                             next_state = JUDGE;
                                        end
                                   end
                              end
                              if(pos == 5'b0) begin
                                   next_pos = 5'd20;
                              end
                         end
                         J: begin
                              for(i = 0;i < 190; i = i + 1) begin
                                   if(map[i] == 1'b1) begin
                                        next_map[i] = 1'b0;
                                        next_map[i + 10] = 1'b1;
                                   end
                              end
                              if(map[10*(pos + 1) + 5] == 1'b1) begin
                                   next_state = JUDGE;
                              end
                              else begin
                                   for(i = 3;i < 6;i = i + 1) begin
                                        if(map[10*pos + i] == 1'b1) begin
                                             next_state = JUDGE;
                                        end
                                   end
                              end
                              for(i = 0;i < 2;i = i + 1) begin
                                   if(map[194 + i] == 1'b1) begin
                                        next_state = JUDGE;
                                   end
                              end
                              if(pos == 5'b0) begin
                                   next_pos = 5'd20;
                              end
                         end
                         L: begin
                              for(i = 0;i < 190; i = i + 1) begin
                                   if(map[i] == 1'b1) begin
                                        next_map[i] = 1'b0;
                                        next_map[i + 10] = 1'b1;
                                   end
                              end
                              if(map[10*(pos + 1) + 3] == 1'b1) begin
                                   next_state = JUDGE;
                              end
                              else begin
                                   for(i = 3;i < 6;i = i + 1) begin
                                        if(map[10*pos + i] == 1'b1) begin
                                             next_state = JUDGE;
                                        end
                                   end
                              end
                              if(pos == 5'b0) begin
                                   next_pos = 5'd20;
                              end
                         end
                         S: begin
                              for(i = 0;i < 190; i = i + 1) begin
                                   if(map[i] == 1'b1) begin
                                        next_map[i] = 1'b0;
                                        next_map[i + 10] = 1'b1;
                                   end
                              end
                              if(map[10*(pos + 1) + 3] == 1'b1 && map[10*(pos + 1) + 4] == 1'b1) begin
                                   next_state = JUDGE;
                              end
                              else if(map[10*pos + 4] == 1'b1 && map[10*pos + 5] == 1'b1) begin
                                   next_state = JUDGE;
                              end
                              else begin
                                   next_state = FALL;
                              end
                              if(pos == 5'b0) begin
                                   next_pos = 5'd20;
                              end
                         end
                         _Z: begin
                              for(i = 0;i < 190; i = i + 1) begin
                                   if(map[i] == 1'b1) begin
                                        next_map[i] = 1'b0;
                                        next_map[i + 10] = 1'b1;
                                   end
                              end
                              if(map[10*(pos + 1) + 4] == 1'b1 && map[10*(pos + 1) + 5] == 1'b1) begin
                                   next_state = JUDGE;
                              end
                              else if(map[10*pos + 3] == 1'b1 && map[10*pos + 4] == 1'b1) begin
                                   next_state = JUDGE;
                              end
                              else begin
                                   next_state = FALL;
                              end
                              if(pos == 5'b0) begin
                                   next_pos = 5'd20;
                              end
                         end
                    endcase
                    if(!valid)
                         {vgaRed, vgaGreen, vgaBlue} = 12'h0;
                    else if(h_cnt < 200 || h_cnt > 440)
                         {vgaRed, vgaGreen, vgaBlue} = 12'h0ff;
                    else begin
                         for(i = 0;i < 200;i = i + 1) begin
                              if(map[i] == 1'b1) begin
                                   if(h_cnt > (200 + (i%10)*24) && h_cnt < (200 + (i%10 + 1)*24) && v_cnt < ((i + 1)*24/10) && v_cnt > (24*i/10)) begin
                                        {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
                                   end
                                   else begin
                                        {vgaRed, vgaGreen, vgaBlue} = 12'h0;
                                   end
                              end
                              else begin
                                   if(h_cnt > (200 + (i%10)*24) && h_cnt < (200 + (i%10 + 1)*24) && v_cnt < ((i + 1)*24/10) && v_cnt > (24*i/10)) begin
                                        {vgaRed, vgaGreen, vgaBlue} = 12'h0;
                                   end
                                   else begin
                                        {vgaRed, vgaGreen, vgaBlue} = 12'h0;
                                   end
                              end
                         end
                    end
               end
               JUDGE: begin
                    next_count = count + 3'd1;
                    for(j = 0;j < 20;j = j + 1) begin
                         for(i = 0;i < 10;i = i + 1) begin
                              if(map[j*10 + i] == 1'b1) begin
                                   next_drop = 1'b1;
                              end
                              else begin
                                   next_drop = 1'b0;
                              end
                         end
                         if(drop == 1'b1) begin
                              next_state = JUDGE;
                              for(k = j;k > 1;k = k - 1) begin
                                   for(l = 0;l < 10;l = l + 1) begin
                                        next_map[10*k + l] = map[10*(k - 1) + l];
                                   end
                              end
                         end
                    end
                    if(drop == 1'b0) begin
                         if(count % 7 == 0) begin
                              next_block = I;
                              next_map[6:3] = 4'b1111;
                         end
                         else if(count % 7 == 1) begin
                              next_block = O;
                              next_map[5:4] = 2'b11;
                              next_map[15:14] = 2'b11;
                         end
                         else if(count % 7 == 2) begin
                              next_block = T;
                              next_map[5:3] = 3'b111;
                              next_map[14] = 1'b1;
                         end
                         else if(count % 7 == 3) begin
                              next_block = J;
                              next_map[5:3] = 3'b111;
                              next_map[15] = 1'b1;
                         end
                         else if(count % 7 == 4) begin
                              next_block = L;
                              next_map[5:3] = 3'b111;
                              next_map[13] = 1'b1;
                         end
                         else if(count % 7 == 5) begin
                              next_block = S;
                              next_map[5:4] = 2'b11;
                              next_map[14:13] = 2'b11;
                         end
                         else begin
                              next_block = _Z;
                              next_map[4:3] = 2'b11;
                              next_map[15:14] = 2'b11;
                         end
                         next_state = FALL;
                    end
                    for(i = 0;i < 10;i = i + 1) begin
                         if(map[i] == 1'b1) begin
                              next_state = INIT;
                         end
                    end
                    if(!valid)
                         {vgaRed, vgaGreen, vgaBlue} = 12'h0;
                    else if(h_cnt < 200 || h_cnt > 440)
                         {vgaRed, vgaGreen, vgaBlue} = 12'h0ff;
                    else begin
                         for(i = 0;i < 200;i = i + 1) begin
                              if(map[i] == 1'b1) begin
                                   if(h_cnt > (200 + (i%10)*24) && h_cnt < (200 + (i%10 + 1)*24) && v_cnt < ((i + 1)*24/10) && v_cnt > (24*i/10)) begin
                                        {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
                                   end
                                   else begin
                                        {vgaRed, vgaGreen, vgaBlue} = 12'h0;
                                   end
                              end
                              else begin
                                   if(h_cnt > (200 + (i%10)*24) && h_cnt < (200 + (i%10 + 1)*24) && v_cnt < ((i + 1)*24/10) && v_cnt > (24*i/10)) begin
                                        {vgaRed, vgaGreen, vgaBlue} = 12'h0;
                                   end
                                   else begin
                                        {vgaRed, vgaGreen, vgaBlue} = 12'h0;
                                   end
                              end
                         end
                    end
               end
          endcase
     end

     assign init = (state == INIT) ? 1'b1 : 1'b0;
     assign fall = (state == FALL) ? 1'b1 : 1'b0;
     assign judge = (state == JUDGE) ? 1'b1 : 1'b0;
     
endmodule
