module LCD_CTRL(
    input clk,
    input reset,
    input [7:0] IROM_Q,
    input [2:0] cmd,
    input cmd_valid,
    output reg IROM_EN,
    output reg [5:0] IROM_A,
    output reg IRB_RW,
    output reg [7:0] IRB_D,
    output reg [5:0] IRB_A,
    output reg busy,
    output reg done
    );

reg [2:0] cs,ns;
reg [2:0] x,y;
reg [7:0] img[0:63];
wire [7:0] p1,p2,p3,p4;
wire [9:0] avg;

parameter READ   = 3'd0,
          IDLE   = 3'd1,
          INST   = 3'd2,
          OUTPUT = 3'd3,
          END    = 3'd4;

assign p1 = x-1 + {y - 3'd1,3'd0};
assign p2 = x   + {y - 3'd1,3'd0};
assign p3 = x-1 + {y, 3'd0};
assign p4 = x   + {y, 3'd0};
assign avg = ((img[p1] + img[p2]) + (img[p3] + img[p4])) >> 2;


always @(posedge clk or posedge reset) begin
    if(reset) begin
        cs <= READ;
        busy <= 1'd1;
        done <= 1'd0;  // 哭阿 沒加會gg
        IROM_EN <= 1'd0;
        IROM_A <= 6'd0;
        IRB_RW <= 1'd1;
        x <= 3'd4;
        y <= 3'd4;
    end
    else begin
        cs <= ns;
        case (cs)
            READ: begin
                IROM_A <= IROM_A + 6'd1;
                img[IROM_A - 6'd1] <= IROM_Q;
            end 
            IDLE: begin
                busy <= 1'd0;
                img[6'd63] <= IROM_Q;
            end
            INST: begin
                if(cmd_valid) begin
                    case (cmd)
                        0: begin  // Write
                            busy <= 1'd1;
                            IRB_RW <= 1'd0;
                            IRB_A <= 6'd0;
                            IRB_D <= img[0];
                        end
                        1: begin  // Shift Up
                            y <= (y > 3'd1) ? y - 3'd1 : 3'd1;
                        end
                        2: begin  // Shift Down
                            y <= (y < 3'd7) ? y + 3'd1 : 3'd7;
                        end
                        3: begin  // Shift Left
                            x <= (x > 3'd1) ? x - 3'd1 : 3'd1;
                        end
                        4: begin  // Shift Right
                            x <= (x < 3'd7) ? x + 3'd1 : 3'd7;
                        end
                        5: begin  // Averge
                            img[p1] <= avg; img[p2] <= avg;
                            img[p3] <= avg; img[p4] <= avg;
                        end
                        6: begin  // Mirror X
                            img[p1] <= img[p3]; img[p3] <= img[p1];
                            img[p2] <= img[p4]; img[p4] <= img[p2];
                        end
                        7: begin  // Mirror Y
                            img[p1] <= img[p2]; img[p2] <= img[p1];
                            img[p3] <= img[p4]; img[p4] <= img[p3];
                        end
                    endcase
                end
                
            end
            OUTPUT: begin
                IRB_A <= IRB_A + 6'd1;
                IRB_D <= img[IRB_A + 6'd1];
            end
            END: begin
                busy <= 1'd0;
                done <= 1'd1;
            end
        endcase
    end
end

always @(*) begin
    case (cs)
        READ: ns = (IROM_A == 6'd63) ? IDLE : READ;
        IDLE: ns = INST;
        INST: ns = (IRB_RW == 1'd0) ? OUTPUT : INST;
        OUTPUT: ns = (IRB_A == 6'd63) ? END : OUTPUT;
        default: ns = END;
    endcase
end

endmodule

