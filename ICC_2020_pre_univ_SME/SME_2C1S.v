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

reg [1:0] cs, ns;
reg [7:0] string[0:31], pattern[0:9];
reg [5:0] str_len, str_counter;
reg [3:0] pat_len, pat_counter;
reg str_begin, begin_match, end_match, char_match, any_match;

parameter [1:0] LOAD    = 2'd0,
                MATCH   = 2'd1,
                OUTPUT  = 2'd2;


always @(*) begin  // Output logic
    //   ^ = 8'd94     $ = 8'd36     . = 8'd46
    str_begin = match_index == 5'd0 && pattern[pat_counter] == 8'd94;
    begin_match = pattern[pat_counter] == 8'd94 && string[match_index] == 8'd32;
    end_match = pattern[pat_counter] == 8'd36 && ((match_index + pat_len) == str_len + 6'd1 || string[match_index + str_counter] == 8'd32);
    char_match = string[match_index + str_counter] == pattern[pat_counter] || pattern[pat_counter] == 8'd46;
    any_match = begin_match || end_match || char_match;
end

always @( posedge clk or posedge reset ) begin  // state register
    if( reset ) begin
        cs <= LOAD;
        str_len <= 6'd0;
        pat_len <= 4'd0;
    end
    else begin
        cs <= ns;
        case (cs)
            LOAD: begin
                valid <= 1'd0;
                match <= 1'd0;
                match_index <= 5'd0;
                str_counter <= 6'd0;
                pat_counter <= 4'd0;

                if(isstring) begin
                    if(valid) begin
                        str_len <= 6'd1;
                        string[0] <= chardata;
                    end
                    else begin
                        str_len <= str_len + 6'd1;
                        string[str_len] <= chardata;
                    end
                end
                pat_len <= (ispattern) ? pat_len + 4'd1 : pat_len;
                pattern[pat_len] <= (ispattern) ? chardata : 8'd0;
            end
            MATCH: begin  
                str_counter <= (str_begin) ? str_counter : (any_match) ? str_counter + 6'd1 : 6'd0;
                pat_counter <= (any_match || str_begin) ? pat_counter + 4'd1 : 4'd0;
                match_index <= (any_match || str_begin) ? match_index : match_index + 5'd1;
            end
            OUTPUT: begin
                valid <= 1'd1;
                match <= (pat_counter == pat_len);
                match_index <= (pattern[0] == 8'd94 && match_index != 5'd0) ? match_index + 5'd1 : match_index;
                pat_len <= 4'd0;
            end
        endcase
    end
end

always @(*) begin  // next state logic
    case (cs)
        LOAD: ns = (isstring || ispattern) ? LOAD : MATCH;
        MATCH: ns = (pat_counter == pat_len - 5'd1 && (any_match || str_begin)) ? OUTPUT :
                            ((pat_len + match_index) > str_len + 6'd1) ? OUTPUT : MATCH;
        default: ns = LOAD;
    endcase
end

endmodule