`timescale 1ns/10ps
module GPSDC(clk, reset_n, DEN, LON_IN, LAT_IN, COS_ADDR, COS_DATA, ASIN_ADDR, ASIN_DATA, Valid, a, D);
input               clk;
input               reset_n;
input               DEN;
input       [23:0]  LON_IN;
input       [23:0]  LAT_IN;
input       [95:0]  COS_DATA;
output reg  [6:0]   COS_ADDR;
input       [127:0] ASIN_DATA;
output reg  [5:0]   ASIN_ADDR;
output reg          Valid;
output wire [39:0]  D;
output reg [63:0]   a;

reg [7:0] counter;
reg [3:0] current_state, next_state;
parameter   IDLE    = 4'd0,
            LOAD_A  = 4'd1,
            TABLE_A = 4'd2,
            MULTI_0 = 4'd3,
            LOAD_B  = 4'd4,
            TABLE_B = 4'd5,
            MULTI_1 = 4'd6,
            TABLE_D = 4'd7,
            MULTI_2 = 4'd8,
            OUTPUT  = 4'd9,
            END     = 4'd10;


reg [3:0] state;
reg [7:-16] LON_A, LAT_A, LON_B, LAT_B;
reg [-1:-64] a_sin2_1, a_sin2_2;
reg [-1:-128] ans_asin_D;

parameter rad = 16'h477; // 0.017453292  (0,16)
parameter   R = 32'd12756274; // 12756274  (32,0)

// Multiplier
wire [63:-64] multi_ans;
reg [31:-32] data_1, data_2;
assign multi_ans = data_1 * data_2;

wire [-1:-16] abs_LON, abs_LAT;
assign abs_LON = (LON_A > LON_B) ? LON_A - LON_B : LON_B - LON_A;
assign abs_LAT = (LAT_A > LAT_B) ? LAT_A - LAT_B : LAT_B - LAT_A;
//assign a_sin_1 = (abs_LAT * rad) >> 1;
//assign a_sin_2 = (abs_LON * rad) >> 1;
//assign a_sin2_1 = a_sin_1[-1:-32] * a_sin_1[-1:-32];  // (0,64)
//assign a_sin2_2 = a_sin_2[-1:-32] * a_sin_2[-1:-32];  // (0,64)
//assign ans_cos = ans_cos_A[-1:-64] * ans_cos_B[-1:-64];  // (0,128)
//assign ans_sin_cos = ans_cos[-1:-64] * a_sin2_2;  // (0,128)
//assign a = a_sin2_1 + ans_sin_cos;  // (0,64)
assign D = multi_ans[7:-32];  // (8,32)

reg [-1:-48] y_0,y_1,x_1,x_0,x_;
reg [-1:-64] ans_cos_A, ans_cos_B;
reg [47:-64] ans_reg;


always @(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        current_state <= IDLE;
        COS_ADDR <= 7'd0;
        ASIN_ADDR <= 6'd0;
        Valid <= 1'd0;
        D <= 40'd0;
        a <= 64'd0;
        data_1 <= 64'd0;
        data_2 <= 64'd0;
        y_0 <= 50'd0;
        y_1 <= 50'd0;
        x_1 <= 50'd0;
        x_0 <= 50'd0;
        x_  <= 50'd0;
        ans_cos_A <= 66'd0;
        ans_cos_B <= 66'd0;
        ans_reg <= 112'd0;
        state <= 4'd0;
        LON_A <= 24'd0;
        LAT_A <= 24'd0;
        LON_B <= 24'd0;
        LAT_B <= 24'd0;
        a_sin2_1 <= 66'd0; a_sin2_2 <= 66'd0;;
        ans_asin_D <= 128'd0;
    end
    else begin
        current_state <= next_state;
        case (current_state)
            IDLE: begin
                COS_ADDR <= 7'd0;
                ASIN_ADDR <= 6'd0;
                state <= 4'd0;
            end
            LOAD_A: begin
                Valid <= 1'd0;
                LON_A <= LON_IN;
                LAT_A <= LAT_IN;
            end
            TABLE_A: begin
                COS_ADDR <= COS_ADDR + 7'd1;
                if(COS_DATA[87:64] < LAT_A) begin
                    x_0 <= COS_DATA[95:48];
                    y_0 <= COS_DATA[47:0];
                end
                else begin
                    x_ <= {8'd0, LAT_A, 16'd0};
                    x_1 <= COS_DATA[95:48];
                    y_1 <= COS_DATA[47:0];
                end
            end
            MULTI_0: begin
                state <= (state == 4'd3) ? 4'd0 : state + 4'd1;
                case (state)
                    0: begin
                        //assign ans_reg = ((y_0 * (x_1 - x_0) + (x_ - x_0) * (y_1- y_0)) << 32);
                        data_1 <= y_0;
                        data_2 <= (x_1 - x_0);
                    end 
                    1: begin
                        ans_reg <= multi_ans;
                        //assign ans_reg = ((y_0 * (x_1 - x_0) + (x_ - x_0) * (y_1- y_0)) << 32);
                        data_1 <= (x_ - x_0);
                        data_2 <= (y_1 - y_0);
                    end
                    2: begin
                        ans_reg <= (ans_reg + multi_ans) << 32;
                        x_1 <= (x_1 - x_0);
                    end
                    3: begin
                        ans_cos_A <= (ans_reg / x_1);
                    end
                endcase
            end
            LOAD_B: begin
                COS_ADDR <= 7'd0;
                ASIN_ADDR <= 6'd0;
                Valid <= 1'd0;
                LON_B <= LON_IN;
                LAT_B <= LAT_IN;
            end
            TABLE_B: begin
                COS_ADDR <= COS_ADDR + 7'd1;
                if(COS_DATA[87:64] < LAT_B) begin
                    x_0 <= COS_DATA[95:48];
                    y_0 <= COS_DATA[47:0];
                end
                else begin
                    x_ <= {8'd0, LAT_B, 16'd0};
                    x_1 <= COS_DATA[95:48];
                    y_1 <= COS_DATA[47:0];
                end
            end 
            MULTI_1: begin
                state <= state + 4'd1;
                case (state)
                    0: begin
                        //assign ans_reg = ((y_0 * (x_1 - x_0) + (x_ - x_0) * (y_1- y_0)) << 32);
                        data_1 <= y_0;
                        data_2 <= (x_1 - x_0);
                    end 
                    1: begin
                        ans_reg <= multi_ans;
                        //assign ans_reg = ((y_0 * (x_1 - x_0) + (x_ - x_0) * (y_1- y_0)) << 32);
                        data_1 <= (x_ - x_0);
                        data_2 <= (y_1 - y_0);
                    end
                    2: begin
                        ans_reg <= (ans_reg + multi_ans) << 32;
                        x_1 <= (x_1 - x_0);
                    end
                    3: begin
                        ans_cos_B <= (ans_reg / x_1);
                    end
                    4: begin
                        //assign a_sin_1 = (abs_LAT * rad) >> 1;
                        data_1 <= abs_LAT;
                        data_2 <= rad;
                    end
                    5: begin
                        //assign a_sin_2 = (abs_LON * rad) >> 1;
                        data_1 <= multi_ans >> 1;
                        data_2 <= multi_ans >> 1;
                    end
                    6: begin
                        a_sin2_1 <= multi_ans;
                        //assign a_sin2_1 = a_sin_1[-1:-32] * a_sin_1[-1:-32];  // (0,64)
                        data_1 <= abs_LON;
                        data_2 <= rad;
                    end
                    7: begin
                        //assign a_sin2_2 = a_sin_2[-1:-32] * a_sin_2[-1:-32];  // (0,64)
                        data_1 <= multi_ans >> 1;
                        data_2 <= multi_ans >> 1;
                    end
                    8: begin
                        a_sin2_2 <= multi_ans;
                        //assign ans_cos = ans_cos_A[-1:-64] * ans_cos_B[-1:-64];  // (0,128)
                        data_1 <= ans_cos_A[-1:-64];
                        data_2 <= ans_cos_B[-1:-64];
                    end
                    9: begin
                        //assign ans_sin_cos = ans_cos[-1:-64] * a_sin2_2;  // (0,128)
                        data_1 <= multi_ans[63:0];
                        data_2 <= a_sin2_2;
                    end
                    10: begin
                        a <= a_sin2_1 + multi_ans[63:0];
                    end
                endcase
            end
            TABLE_D: begin
                ASIN_ADDR <= ASIN_ADDR + 6'd1;
                if(ASIN_DATA[127:64] <= a) begin
                    x_0 <= ASIN_DATA[127:64];
                    y_0 <= ASIN_DATA[63:0];
                end
                else begin
                    x_ <= a;
                    x_1 <= ASIN_DATA[127:64];
                    y_1 <= ASIN_DATA[63:0];
                end
            end
            MULTI_2: begin
                state <= (state == 4'd4) ? 4'd0 : state + 4'd1;
                case (state)
                    0: begin
                        //assign ans_reg = ((y_0 * (x_1 - x_0) + (x_ - x_0) * (y_1- y_0)) << 32);
                        data_1 <= y_0;
                        data_2 <= (x_1 - x_0);
                    end 
                    1: begin
                        ans_reg <= multi_ans;
                        //assign ans_reg = ((y_0 * (x_1 - x_0) + (x_ - x_0) * (y_1- y_0)) << 32);
                        data_1 <= (x_ - x_0);
                        data_2 <= (y_1 - y_0);
                    end
                    2: begin
                        ans_reg <= (ans_reg + multi_ans);
                        x_1 <= (x_1 - x_0);
                    end
                    3: begin
                        ans_asin_D <= (ans_reg / x_1);  
                    end
                    4: begin
                        Valid <= 1'd1;
                        //assign D_result = R * ans_asin_D[-1:-64];  // (32, 64)
                        data_1 <= R;
                        data_2 <= ans_asin_D[-65:-128];  // 修正除法位移
                    end  
                endcase
            end
            OUTPUT: begin
                Valid <= 1'd0;
                LON_A <= LON_B;
                LAT_A <= LAT_B;
                ans_cos_A <= ans_cos_B;
            end  
        endcase
    end
end

always @(*) begin
    case (current_state)
        IDLE: next_state = LOAD_A;
        LOAD_A: next_state = (DEN == 1'd1) ? TABLE_A : LOAD_A;
        TABLE_A: begin
            if(COS_DATA[87:64] > LAT_A)
                next_state = MULTI_0;
            else
                next_state = TABLE_A;
        end 
        MULTI_0: begin
            if(state == 4'd3)
                next_state = LOAD_B;
            else
                next_state = MULTI_0;
        end
        LOAD_B: next_state = (DEN == 1'd1) ? TABLE_B : LOAD_B;
        TABLE_B: begin
            if(COS_DATA[87:64] > LAT_B)
                next_state = MULTI_1;
            else
                next_state = TABLE_B;
        end
        MULTI_1: begin
            if(state == 4'd15)
                next_state = TABLE_D;
            else
                next_state = MULTI_1;
        end
        TABLE_D: begin
            if(ASIN_DATA[127:64] > a)
                next_state = MULTI_2;
            else
                next_state = TABLE_D;
        end
        MULTI_2: begin
            if(state == 4'd4)
                next_state = OUTPUT;
            else
                next_state = MULTI_2;
        end
        OUTPUT: next_state = LOAD_B;
        default: next_state = END;
    endcase
end

endmodule
