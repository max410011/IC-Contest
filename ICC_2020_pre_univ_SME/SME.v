module SME(
    input clk,
    input reset,
    input [7:0] chardata,
    input isstring,
    input ispattern,
    output reg match,
    output reg [4:0] match_index,
    output reg valid
);

reg [1:0] current_state, next_state;
reg [7:0] string[0:31];
reg [7:0] pattern[0:9];
reg [5:0] string_len, pattern_len;
reg [4:0] str_counter, pat_counter;
reg change_string;

integer i;
parameter [1:0] LOAD    = 2'd0,
                MATCH   = 2'd1,
                OUTPUT  = 2'd2;


always @( posedge clk or posedge reset ) begin
    if( reset ) begin
        current_state <= LOAD;
        string_len <= +'d0;
        pattern_len <= 6'd0;
        change_string <= 1'd0;
    end
    else begin
        current_state <= next_state;
        case (current_state)
            LOAD: begin
                valid <= 1'd0;
                match <= 1'd0;
                match_index <= 5'd0;
                str_counter <= 5'd0;
                pat_counter <= 5'd0;

                if(isstring) begin
                    if(change_string) begin
                        change_string <= 1'd0;
                        string_len <= +'d1;
                        string[0] <= chardata;
                    end
                    else begin
                        string_len <= string_len + +'d1;
                        string[string_len] <= chardata;
                    end
                end
                pattern_len <= (ispattern) ? pattern_len + 6'd1 : pattern_len;
                pattern[pattern_len] <= (ispattern) ? chardata : 8'd0;
            end
            MATCH: begin  //   ^ = 8'd94     & = 8'd36     . = 8'd46
                if(pat_counter == pattern_len) begin
                    match <= 1'd1;
                end
                else begin
                    case (pattern[pat_counter])
                        8'd94: begin
                            if(match_index == 5'd0) begin
                                pat_counter <= pat_counter + 5'd1;
                            end
                            else if(string[match_index] == 8'd32) begin
                                str_counter <= str_counter + 5'd1;
                                pat_counter <= pat_counter + 5'd1;
                            end
                            else begin
                                match_index <= match_index + 5'd1;
                                str_counter <= 5'd0;
                                pat_counter <= 5'd0;
                            end
                        end
                        8'd36: begin
                            if((match_index + pattern_len) == string_len + +'d1 || string[match_index + str_counter] == 8'd32) begin
                                str_counter <= str_counter + 5'd1;
                                pat_counter <= pat_counter + 5'd1;
                            end
                            else begin
                                match_index <= match_index + 5'd1;
                                str_counter <= 5'd0;
                                pat_counter <= 5'd0;
                            end
                        end
                        default: begin
                            if(string[match_index + str_counter] == pattern[pat_counter] || pattern[pat_counter] == 8'd46) begin
                                str_counter <= str_counter + 5'd1;
                                pat_counter <= pat_counter + 5'd1;
                            end
                            else begin
                                match_index <= match_index + 5'd1;
                                str_counter <= 5'd0;
                                pat_counter <= 5'd0;
                            end
                        end 
                    endcase    
                end
            end
            OUTPUT: begin
                valid <= 1'd1;
                change_string <= 1'd1;
                match_index <= (pattern[0] == 8'd94 && match_index != 5'd0) ? match_index + 5'd1 : match_index;
                pattern_len <= 6'd0;
            end
        endcase
    end
end

always @(*) begin
    case (current_state)
        LOAD: begin
            if( isstring == 1'd0 && ispattern == 1'd0 ) 
                next_state = MATCH;
            else
                next_state = LOAD;
        end 
        MATCH: begin
            next_state =   (match) ? OUTPUT :
                            (({1'b0, match_index} + pattern_len) > string_len + 6'd1) ? OUTPUT : MATCH;
        end
        OUTPUT: begin
            next_state = LOAD;
        end
        default: begin
            next_state = LOAD;
        end 
    endcase
end



endmodule
