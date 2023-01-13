module geofence ( clk,reset,X,Y,valid,is_inside);
input clk;
input reset;
input [9:0] X;
input [9:0] Y;
output reg valid;
output reg is_inside;

reg [2:0] current_state, next_state;
reg [2:0] counter, counter2;
reg signed [10:0] reg_x[0:5], reg_y[0:5], obj_x, obj_y;
reg signed [10:0] buffer_1, buffer_2;
reg signed [20:0] mul_pre;
wire signed [20:0] mul;

parameter Object = 3'd0,
          Input  = 3'd1,
          Sort_1 = 3'd2,
          Sort_2 = 3'd3,
          Find_1 = 3'd4,
          Find_2 = 3'd5,
          Output = 3'd6;
/*
reg signed [10:0] x0,x1,x2,x3,x4,x5, y0,y1,y2,y3,y4,y5;
always @(*) begin
    x0 = reg_x[0]; x1 = reg_x[1]; x2 = reg_x[2]; x3 = reg_x[3]; x4 = reg_x[4]; x5 = reg_x[5];
    y0 = reg_y[0]; y1 = reg_y[1]; y2 = reg_y[2]; y3 = reg_y[3]; y4 = reg_y[4]; y5 = reg_y[5];
end
*/

assign mul = buffer_1 * buffer_2;



always @(*) begin
    
    case (current_state)
        Sort_1: begin
            buffer_1 = reg_x[counter] - reg_x[0];   // Ax
            buffer_2 = reg_y[counter2] - reg_y[0];  // By
        end
        Sort_2: begin
            buffer_1 = reg_x[counter2] - reg_x[0];  // Bx
            buffer_2 = reg_y[counter] - reg_y[0];   // Ay
        end
        Find_1: begin
            buffer_1 = reg_x[counter] - obj_x;   // Ax
            buffer_2 = reg_y[counter + 3'd1] - reg_y[counter];  // By
        end
        default: begin
            buffer_1 = reg_x[counter + 3'd1] - reg_x[counter];  // Bx
            buffer_2 = reg_y[counter] - obj_y;   // Ay
        end
    endcase   
end


always @(posedge clk or posedge reset) begin
    if(reset) begin
        current_state <= 2'd0;
        valid <= 1'd0;
        counter <= 3'd0;
        counter2 <= 3'd2;
    end 
    else begin
        current_state <= next_state;
        case (current_state)
            Object: begin
                valid <= 1'd0;
                is_inside <= 1'd1;
                obj_x <= X;
                obj_y <= Y;
            end
            Input: begin
                counter <= (counter == 3'd5) ? 3'd1 : counter + 3'd1; 
                counter2 <= 3'd2;
                reg_x[counter] <= X;
                reg_y[counter] <= Y;
            end
            Sort_1: begin
                mul_pre <= mul;
            end
            Sort_2: begin
                counter <= (counter2 < 3'd5) ? counter : (counter == 3'd4) ? 3'd0 : counter + 3'd1;
                counter2 <= (counter2 == 3'd5) ? counter + 3'd2 : counter2 + 3'd1;

                if(mul_pre > mul) begin
                    reg_x[counter] <= reg_x[counter2];
                    reg_y[counter] <= reg_y[counter2];
                    reg_x[counter2] <= reg_x[counter];
                    reg_y[counter2] <= reg_y[counter];
                end
            end
            Find_1: begin
                mul_pre <= mul;
            end
            Find_2: begin
                counter <= (counter == 3'd4) ? 3'd0 : counter + 3'd1;
                if(mul_pre > mul) is_inside <= 3'd0;
                valid <= (counter == 3'd4) ? 1'd1 : 1'd0;
            end
            Output: begin
                valid <= 1'd0;
            end 
        endcase
    end   
end

always @(*) begin
    case (current_state)
        Object: next_state = Input;
        Input:  next_state = (counter == 3'd5) ? Sort_1 : Input;
        Sort_1: next_state = Sort_2;
        Sort_2: next_state = (counter == 3'd4 && counter2 == 3'd5) ? Find_1 : Sort_1;
        Find_1: next_state = Find_2;
        Find_2: next_state = (counter == 3'd4) ? Output : Find_1;
        Output: next_state = Object;
        default: next_state = Object;
    endcase
end

endmodule



