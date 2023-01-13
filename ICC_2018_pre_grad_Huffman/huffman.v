module huffman(
input clk,
input reset,
input gray_valid,
input [7:0] gray_data,
output reg CNT_valid,
output reg [7:0] CNT1, CNT2, CNT3, CNT4, CNT5, CNT6,
output reg code_valid,
output reg [7:0] HC1, HC2, HC3, HC4, HC5, HC6,
output reg [7:0] M1, M2, M3, M4, M5, M6
);


reg [7:0] CNT[1:6], HC[1:6], M[1:6];

reg [1:0] current_state, next_state;
reg [6:0] counter;
reg [3:0] group[1:6], max_group, min_group;
reg [2:0] max, min;
reg [7:0] max_CNT, min_CNT;

integer i;
parameter [2:0] LOAD    = 2'd0,
                FIND    = 2'd1,
                COMBINE = 2'd2,
                END     = 2'd3;

always @(*) begin
    CNT1 = CNT[1]; CNT2 = CNT[2]; CNT3 = CNT[3]; CNT4 = CNT[4]; CNT5 = CNT[5]; CNT6 = CNT[6]; //轉換成陣列方便操作
    HC1 = HC[1] >> (8'd8 - M[1]); HC2 = HC[2] >> (8'd8 - M[2]); HC3 = HC[3] >> (8'd8 - M[3]);
    HC4 = HC[4] >> (8'd8 - M[4]); HC5 = HC[5] >> (8'd8 - M[5]); HC6 = HC[6] >> (8'd8 - M[6]);
    M1 = 8'd255 >> (8'd8 - M[1]); M2 = 8'd255 >> (8'd8 - M[2]); M3 = 8'd255 >> (8'd8 - M[3]);
    M4 = 8'd255 >> (8'd8 - M[4]); M5 = 8'd255 >> (8'd8 - M[5]); M6 = 8'd255 >> (8'd8 - M[6]);
end

always @(posedge clk or posedge reset) begin
    if( reset ) begin
        current_state <= LOAD;
        counter <= 7'd0;
        for(i = 1; i <= 6; i = i+1)
            CNT[i] <= 7'd0;
    end
    else begin
        current_state <= next_state;
        case (current_state)
            LOAD: begin
                code_valid <= 1'd0;
                CNT_valid <= (counter == 7'd99) ? 1'd1 : 1'd0;
                if(gray_valid) begin
                    counter <= (counter == 7'd99) ? 7'd2 : counter + 7'd1;
                    CNT[gray_data] <= CNT[gray_data] + 7'd1;
                end

                for(i = 1; i <= 6 ; i = i+1) begin
                    group[i] <= i;
                    HC[i] <= 8'd0;
                    M[i] <= 8'd0;
                end
            end
            FIND: begin
                CNT_valid <= 1'd0;
                counter <= (counter[2:0] == 3'd6) ? counter + 7'd4 : counter + 7'd1;
                case (counter[2:0])
                    2: begin
                        max <= (CNT[1] > CNT[2]) ? 3'd1 : 3'd2;
                        min <= (CNT[1] > CNT[2]) ? 3'd2 : 3'd1;
                        max_CNT <= (CNT[1] > CNT[2]) ? CNT[1] : CNT[2];
                        min_CNT <= (CNT[1] > CNT[2]) ? CNT[2] : CNT[1];
                        max_group <= (CNT[1] > CNT[2]) ? group[1] : group[2];
                        min_group <= (CNT[1] > CNT[2]) ? group[2] : group[1];
                    end
                    default: begin
                        if(CNT[counter[2:0]] <= max_CNT) begin
                            max <= (CNT[counter[2:0]] < min_CNT || CNT[counter[2:0]] == min_CNT && group[counter[2:0]] > min_group) ? min : counter[2:0];
                            min <= (CNT[counter[2:0]] < min_CNT || CNT[counter[2:0]] == min_CNT && group[counter[2:0]] > min_group) ? counter[2:0] : min;
                            max_CNT <= (CNT[counter[2:0]] < min_CNT || CNT[counter[2:0]] == min_CNT && group[counter[2:0]] > min_group) ? min_CNT : CNT[counter[2:0]];
                            min_CNT <= (CNT[counter[2:0]] < min_CNT || CNT[counter[2:0]] == min_CNT && group[counter[2:0]] > min_group) ? CNT[counter[2:0]] : min_CNT;
                            max_group <= (CNT[counter[2:0]] < min_CNT || CNT[counter[2:0]] == min_CNT && group[counter[2:0]] > min_group) ? min_group: group[counter[2:0]];
                            min_group <= (CNT[counter[2:0]] < min_CNT || CNT[counter[2:0]] == min_CNT && group[counter[2:0]] > min_group) ? group[counter[2:0]] : min_group;
                        end
                    end
                endcase
            end
            COMBINE: begin
                CNT[max] <= max_CNT + min_CNT;
                CNT[min] <= 8'd255;
                for(i = 1; i <= 6 ; i = i+1) begin
                    if(group[i] == max_group) begin
                        M[i] <= M[i] + 8'd1;
                        HC[i] <= (HC[i] >> 1);
                        group[i] <= counter[6:3] + 4'd6;
                    end
                    else if(group[i] == min_group) begin
                        M[i] <= M[i] + 8'd1;
                        HC[i] <= {1'd1, HC[i][7:1]};
                        group[i] <= counter[6:3] + 4'd6;
                    end
                end
            end
            END: begin
                code_valid <= 1'd1;
            end
        endcase
    end
end


always @(*) begin
    case (current_state)
        LOAD: begin
            next_state = (counter == 7'd99) ? FIND : LOAD;
        end
        FIND: begin
            next_state = (counter[2:0] == 3'd6) ? COMBINE : FIND;
        end
        COMBINE: begin
            next_state = (counter[5:3] == 3'd5) ? END : FIND;
        end
        default: next_state = END;
    endcase
end

endmodule

