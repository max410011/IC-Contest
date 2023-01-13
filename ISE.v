`timescale 1ns/10ps
module ISE( clk, reset, image_in_index, pixel_in, busy, out_valid, color_index, image_out_index);
input               clk;
input               reset;
input       [4:0]   image_in_index;
input       [23:0]  pixel_in;
output  reg         busy;
output  reg         out_valid;
output  reg [1:0]   color_index;
output  reg [4:0]   image_out_index;

reg [2:0]   current_state, next_state;
reg [4:0]   counter, counter2;
reg [4:0]   image_index, final_index[31:0];
reg [1:0]   pixel_color, image_color, final_color[31:0];
reg [8:0]   final_strength[31:0];
reg [13:0]  R_num, G_num, B_num, addr;
reg [21:0]  R_total, G_total, B_total;


parameter   [2:0]   START   = 3'd0,
                    LOAD    = 3'd1,
                    SAVE    = 3'd2,
                    SORT    = 3'd3,
                    OUTPUT  = 3'd4;

parameter   [1:0]   Red     = 2'd0,
                    Green   = 2'd1,
                    Blue    = 2'd2;

always @(*) begin
    if( pixel_in[23:16] >= pixel_in[15:8] && pixel_in[23:16] >= pixel_in[7:0] ) // Red
        pixel_color = Red;
    else if( pixel_in[15:8] >= pixel_in[7:0] && pixel_in[15:8] > pixel_in[23:16] ) // Green
        pixel_color = Green;
    else
        pixel_color = Blue; //Blue

    if( R_num >= G_num && R_num >= B_num ) // Red
        image_color = Red;
    else if( G_num >= B_num && G_num > R_num ) // Green
        image_color = Green;
    else
        image_color = Blue; //Blue
end

always @( posedge clk or posedge reset ) begin
    if( reset ) begin
        current_state <= START;
        counter <= 5'd0;
        counter2 <= 5'd0;
        addr <= 14'd0;
        busy <= 1'd0;
    end
    else begin
        current_state <= next_state;
        case (current_state)
            START: begin
                busy <= 1'd0;
                out_valid <= 1'd0;
                R_total <= 22'd0;
                G_total <= 22'd0;
                B_total <= 22'd0;
                R_num <= 14'd0;
                G_num <= 14'd0;
                B_num <= 14'd0;
            end 
            LOAD: begin
                if( addr == 14'd16383 ) begin
                    busy <= 1'd1;
                    addr <= 14'd0;
                end
                else begin
                    addr <= addr + 14'd1;
                    R_total <= (pixel_color == Red) ? R_total + pixel_in[23:16] : R_total;
                    G_total <= (pixel_color == Green) ? G_total + pixel_in[15:8] : G_total;
                    B_total <= (pixel_color == Blue) ? B_total + pixel_in[7:0] : B_total;
                    R_num <= (pixel_color == Red) ? R_num + 14'd1 : R_num;
                    G_num <= (pixel_color == Green) ? G_num + 14'd1 : G_num;
                    B_num <= (pixel_color == Blue) ? B_num + 14'd1 : B_num;
                end
            end
            SAVE: begin
                counter <= (counter == 5'd31) ? 5'd0 : counter + 5'd1;
                final_index[counter] <= counter;
                case (image_color)
                    Red: begin
                        final_color[counter] <= Red;
                        final_strength[counter] <= {R_total, 1'd0} / R_num;
                    end 
                    Green: begin
                        final_color[counter] <= Green;
                        final_strength[counter] <= {G_total, 1'd0} / G_num;
                    end
                    Blue: begin
                        final_color[counter] <= Blue;
                        final_strength[counter] <= {B_total, 1'd0} / B_num;
                    end
                endcase
            end
            SORT: begin
                counter <= (counter2 == 5'd31) ? counter + 5'd1 : counter;
                counter2 <= (counter2 == 5'd31) ? counter + 5'd1 : counter2 + 5'd1;
                if( final_color[counter] > final_color[counter2] ) begin  // R -> G -> B
                    final_index[counter] <= final_index[counter2];
                    final_color[counter] <= final_color[counter2];
                    final_strength[counter] <= final_strength[counter2];
                    final_index[counter2] <= final_index[counter];
                    final_color[counter2] <= final_color[counter];
                    final_strength[counter2] <= final_strength[counter];
                end
                else if( final_color[counter] == final_color[counter2] && final_strength[counter] > final_strength[counter2] ) begin  // Dark -> Bright
                    final_index[counter] <= final_index[counter2];
                    final_color[counter] <= final_color[counter2];
                    final_strength[counter] <= final_strength[counter2];
                    final_index[counter2] <= final_index[counter];
                    final_color[counter2] <= final_color[counter];
                    final_strength[counter2] <= final_strength[counter];
                end
            end
            OUTPUT: begin
                counter <= (counter == 5'd31) ? 5'd0 : counter + 5'd1;
                out_valid <= 1'd1;
                color_index <= final_color[counter];
                image_out_index <= final_index[counter];
            end
        endcase
    end
end

always @( * ) begin
    case (current_state)
        START: begin
            next_state = LOAD;
        end
        LOAD: begin
            if( addr == 14'd16383 )
                next_state = SAVE;
            else
                next_state = LOAD;
        end
        SAVE: begin
            if( counter == 5'd31 )
                next_state = SORT;
            else
                next_state = START; 
        end
        SORT: begin
            if( counter == 5'd31 )
                next_state = OUTPUT;
            else
                next_state = current_state;
        end
        OUTPUT: begin
            if( counter == 5'd31)
                next_state = START;
            else
                next_state = OUTPUT;
        end
        default: begin
            next_state = START;
        end
    endcase
end

endmodule
