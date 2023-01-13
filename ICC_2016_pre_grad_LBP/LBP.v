
`timescale 1ns/10ps
module LBP ( clk, reset, gray_addr, gray_req, gray_ready, gray_data, lbp_addr, lbp_valid, lbp_data, finish);
input   	        clk;
input   	        reset;
output  reg [13:0] 	gray_addr;
output  reg        	gray_req;
input   	        gray_ready;
input       [7:0] 	gray_data;
output  reg [13:0] 	lbp_addr;
output  reg        	lbp_valid;
output  wire [7:0] 	lbp_data;
output  reg     	finish;
//====================================================================

reg  [2:0]   current_state, next_state;
reg  [3:0]   counter;
reg  [7:0]   buffer[8:0];
wire [13:0]  addr[8:0];

parameter   [2:0]   START   = 3'd0,
                    LOAD_9  = 3'd1,
                    LOAD_3  = 3'd2,
                    STORE   = 3'd3,
                    END     = 3'd4;

assign addr[0] = lbp_addr - 14'd129;
assign addr[1] = lbp_addr - 14'd128;
assign addr[2] = lbp_addr - 14'd127;
assign addr[3] = lbp_addr - 14'd1;
assign addr[4] = lbp_addr;
assign addr[5] = lbp_addr + 14'd1;
assign addr[6] = lbp_addr + 14'd127;
assign addr[7] = lbp_addr + 14'd128;
assign addr[8] = lbp_addr + 14'd129;

assign lbp_data[0] = (buffer[0] >= buffer[4]);
assign lbp_data[1] = (buffer[1] >= buffer[4]);
assign lbp_data[2] = (buffer[2] >= buffer[4]);
assign lbp_data[3] = (buffer[3] >= buffer[4]);
assign lbp_data[4] = (buffer[5] >= buffer[4]);
assign lbp_data[5] = (buffer[6] >= buffer[4]);
assign lbp_data[6] = (buffer[7] >= buffer[4]);
assign lbp_data[7] = (buffer[8] >= buffer[4]);

always @( posedge clk or posedge reset ) begin
    if( reset ) begin
        current_state <= START;
        lbp_addr <= 14'd126;
        counter <= 4'd1; 
        finish <= 1'b0;
        gray_addr <= 14'd0;
    end
    else begin
        current_state <= next_state;
        gray_req <= 1'b1;
        case ( current_state )
            START: begin
                if( lbp_addr[6:0] == 7'b11111110 ) begin    // LOAD_9
                    lbp_addr <= lbp_addr + 14'd3;
                    gray_addr <= addr[counter] + 14'd3;     //修正第一項 (因為lbp_addr在這裡sotre完才能變動)
                    counter <= counter + 4'd1;

                    buffer[0] <= gray_data;
                end
                else begin                                  // LOAD_3
                    lbp_addr <= lbp_addr + 14'd1;
                    gray_addr <= addr[counter] + 14'd1;     //修正第一項 (因為lbp_addr在這裡store完才能變動)
                    counter <= counter + 4'd3;

                    buffer[2] <= gray_data;
                    buffer[0] <= buffer[1];
                    buffer[1] <= buffer[2];
                    buffer[3] <= buffer[4];
                    buffer[4] <= buffer[5];
                    buffer[6] <= buffer[7];
                    buffer[7] <= buffer[8];
                end
                lbp_valid <= 1'b0;
            end 
            LOAD_9: begin
                gray_addr <= addr[counter];
                counter <= (counter == 4'd8) ? 4'd0 : counter + 4'd1;
                buffer[counter - 4'd1] <= gray_data;
            end
            LOAD_3: begin
                gray_addr <= addr[counter];
                counter <= (counter == 4'd8) ? 4'd0 : counter + 4'd3;
                buffer[counter - 4'd3] <= gray_data;
            end
            STORE: begin
                buffer[8] <= gray_data;
                lbp_valid <= 1'b1;
                if( lbp_addr[6:0] == 7'b11111110 ) begin    // LOAD_9
                    gray_addr <= addr[counter] + 14'd3;     // 在store的同時也繼續跟gray要資料
                    counter <= 4'd1;
                end
                else begin                                  // LOAD_3
                    gray_addr <= addr[counter] + 14'd3;     // 在store的同時也繼續跟gray要資料
                    counter <= 4'd5;
                end
            end
            END: begin
                finish <= 1'b1;
            end
            default: begin
                finish <= 1'b1;
            end 
        endcase
    end
end


always @(*) begin
    case ( current_state )
        START: begin
            next_state = (lbp_addr[6:0] == 7'b11111110) ? LOAD_9 : LOAD_3;
        end 
        LOAD_9: begin
            next_state = (counter == 4'd8) ? STORE : LOAD_9; 
        end
        LOAD_3: begin
            next_state = (counter == 4'd8) ? STORE : LOAD_3; 
        end
        STORE: begin
            next_state = (lbp_addr == 14'd16254) ? END : START;
        end
        END: begin
            next_state = START;
        end
        default: begin
            next_state = START;
        end
    endcase
end

//====================================================================
endmodule
