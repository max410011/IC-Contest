module huffman(clk, reset, gray_valid, gray_data,CNT_valid, CNT1, CNT2, CNT3, CNT4, CNT5, CNT6,
    code_valid, HC1, HC2, HC3, HC4, HC5, HC6, M1, M2, M3, M4, M5, M6);

input clk;
input reset;
input gray_valid;
input [7:0] gray_data;
output reg CNT_valid;
output reg [7:0] CNT1, CNT2, CNT3, CNT4, CNT5, CNT6;
output reg code_valid;
output reg [7:0] HC1, HC2, HC3, HC4, HC5, HC6;
output reg [7:0] M1, M2, M3, M4, M5, M6;
  
reg [7:0] CNT[1:6], HC[1:6], M[1:6];
reg [2:0] CNT_num[1:6];

reg [2:0] current_state, next_state;
reg [6:0] counter;
reg [2:0] counter_2;
reg [2:0] group[1:6];
reg [2:0] max_group, min_group;
reg [2:0] max, min;
reg [7:0] max_CNT, min_CNT;
reg [2:0] group_1, group_2, group_3, group_4, group_5, group_6;
reg [2:0] num_1, num_2, num_3, num_4, num_5, num_6;

integer i;
parameter [2:0] LOAD    = 3'd0,
                INIT    = 3'd1,
                FIND    = 3'd2,
                COMBINE = 3'd3,
                END     = 3'd4;

always @(*) begin
    CNT1 = CNT[1]; CNT2 = CNT[2]; CNT3 = CNT[3]; 
    CNT4 = CNT[4]; CNT5 = CNT[5]; CNT6 = CNT[6];
    
    HC1 = HC[1] >> (8'd8 - M[1]); HC2 = HC[2] >> (8'd8 - M[2]); HC3 = HC[3] >> (8'd8 - M[3]);
    HC4 = HC[4] >> (8'd8 - M[4]); HC5 = HC[5] >> (8'd8 - M[5]); HC6 = HC[6] >> (8'd8 - M[6]);
    M1 = 8'd255 >> (8'd8 - M[1]); M2 = 8'd255 >> (8'd8 - M[2]); M3 = 8'd255 >> (8'd8 - M[3]);
    M4 = 8'd255 >> (8'd8 - M[4]); M5 = 8'd255 >> (8'd8 - M[5]); M6 = 8'd255 >> (8'd8 - M[6]);


    num_1 = CNT_num[1]; num_2 = CNT_num[2]; num_3 = CNT_num[3];
    num_4 = CNT_num[4]; num_5 = CNT_num[5]; num_6 = CNT_num[6];
    group_1 = group[1]; group_2 = group[2]; group_3 = group[3];
    group_4 = group[4]; group_5 = group[5]; group_6 = group[6];
end

always @(posedge clk or posedge reset) begin
    if( reset ) begin
        current_state <= LOAD;
        code_valid <= 1'd0;
        counter <= 7'd0;
        for(i = 1; i <= 6; i = i+1) begin
            CNT[i] <= 7'd0;
            CNT_num[i] <= i;
        end
    end
    else begin
        current_state <= next_state;
        case (current_state)
            LOAD: begin
                if(gray_valid) begin
                    CNT_valid <= (counter == 7'd99) ? 1'd1 : 1'd0;
                    counter <= (counter == 7'd99) ? 7'd0 : counter + 7'd1;
                    CNT[gray_data] <= CNT[gray_data] + 7'd1;
                end
            end
            INIT: begin
                CNT_valid <= 1'd0;
                for(i = 1; i <= 6 ; i = i+1) begin
                    group[i] <= i;
                    HC[i] <= 8'd0;
                    M[i] <= 8'd0;
                end
                counter <= (counter == 7'd8) ? 7'd0 : counter + 7'd1;
                counter_2 <= 3'd0;
                if(counter[0] == 1'd1) begin
                    for(i = 1; i <= 5; i = i+2) begin
                        if(CNT[i] < CNT[i+1]) begin
                            CNT[i] <= CNT[i+1];
                            CNT[i+1] <= CNT[i];
                            CNT_num[i] <= CNT_num[i+1];
                            CNT_num[i+1] <= CNT_num[i];
                        end
                    end    
                end
                else begin
                    for(i = 2; i <= 4; i = i+2) begin
                        if(CNT[i] < CNT[i+1]) begin
                            CNT[i] <= CNT[i+1];
                            CNT[i+1] <= CNT[i];
                            CNT_num[i] <= CNT_num[i+1];
                            CNT_num[i+1] <= CNT_num[i];
                        end
                    end 
                end
            end
            FIND: begin
                counter <= (counter == 7'd6) ? 7'd2 : counter + 7'd1;
                case (counter)
                    2: begin
                        max <= (CNT[1] >= CNT[2]) ? 3'd1 : 3'd2;
                        min <= (CNT[1] >= CNT[2]) ? 3'd2 : 3'd1;
                        max_CNT <= (CNT[1] >= CNT[2]) ? CNT[1] : CNT[2];
                        min_CNT <= (CNT[1] >= CNT[2]) ? CNT[2] : CNT[1];
                        max_group <= (CNT[1] >= CNT[2]) ? group[1] : group[2];
                        min_group <= (CNT[1] >= CNT[2]) ? group[2] : group[1];
                    end
                    default: begin
                        if(CNT[counter] <= max_CNT) begin
                            max <= (CNT[counter] <= min_CNT) ? min : counter;
                            min <= (CNT[counter] <= min_CNT) ? counter : min;
                            max_CNT <= (CNT[counter] <= min_CNT) ? min_CNT : CNT[counter];
                            min_CNT <= (CNT[counter] <= min_CNT) ? CNT[counter] : min_CNT;
                            max_group <= (CNT[counter] <= min_CNT) ? min_group: group[counter];
                            min_group <= (CNT[counter] <= min_CNT) ? group[counter] : min_group;
                        end
                    end
                endcase
            end
            COMBINE: begin
                counter_2 <= counter_2 + 3'd1;
                CNT[max] <= max_CNT + min_CNT;
                for(i = 1; i <= 6 ; i = i+1) begin
                    if(group[i] == max_group) begin
                        M[CNT_num[i]] <= M[CNT_num[i]] + 8'd1;
                        HC[CNT_num[i]] <= (HC[CNT_num[i]] >> 1);
                    end
                    else if(group[i] == min_group) begin
                        CNT[i] <= 8'd255;
                        M[CNT_num[i]] <= M[CNT_num[i]] + 8'd1;
                        HC[CNT_num[i]] <= {1'd1, HC[CNT_num[i]][7:1]};
                        group[i] <= max_group;
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
            next_state = (counter == 7'd99) ? INIT : LOAD;
        end
        INIT: begin
            next_state = (counter == 7'd8) ? FIND : INIT;
        end
        FIND: begin
            next_state = (counter == 7'd6) ? COMBINE : FIND;
        end
        COMBINE: begin
            next_state = (counter_2 == 3'd4) ? END : FIND;
        end
        default: next_state = END;
    endcase
end

endmodule

