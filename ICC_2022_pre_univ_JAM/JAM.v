module JAM (
    input CLK,
    input RST,
    output reg [2:0] W,
    output reg [2:0] J,
    input [6:0] Cost,
    output reg [3:0] MatchCount,
    output reg [9:0] MinCost,
    output reg Valid
);

reg [2:0] cs,ns;
reg [2:0] arr[0:7];
reg [2:0] counter;
reg [9:0] Cost_sum;
reg [2:0] change_pt, min_pt;
integer i;

parameter Find_pt  = 3'd0,
          Find_min = 3'd1,
          Change   = 3'd2,
          Find     = 3'd3,
          Cal      = 3'd4,
          Output   = 3'd5;

reg [2:0] x0,x1,x2,x3,x4,x5,x6,x7;
always @(*) begin
    x0 = arr[0]; x1 = arr[1]; x2 = arr[2]; x3 = arr[3]; x4 = arr[4]; x5 = arr[5]; x6 = arr[6]; x7 = arr[7];
end

reg [31:0] total;

always @(*) begin
    W = counter;
    J = arr[counter];
end

always @(posedge CLK or posedge RST) begin
    if(RST) begin
        cs <= Find_pt;
        for(i=0; i<=7;i=i+1)
            arr[i] <= i;
        Valid <= 1'd0;
        counter <= 3'd0;
        MatchCount <= 4'd0;
        MinCost <= 10'd1023;
        Cost_sum <= 10'd0;
        change_pt <= 3'd6;
        min_pt <= 3'd6;
        total <= 32'd0;
    end 
    else begin
        cs <= ns;
        case (cs)
            Find_pt: begin
                if(arr[change_pt] < arr[change_pt + 3'd1]) begin   // 找到替換點
                    change_pt <= change_pt;
                    counter <= change_pt + 3'd1;
                    min_pt <= change_pt + 3'd1;
                end
                else begin
                    change_pt <= change_pt - 3'd1;
                    counter <= 3'd0;
                    min_pt <= 3'd0;
                end
                Cost_sum <= 10'd0;
            end
            Find_min: begin
                counter <= (counter == 3'd7) ? 3'd0 : counter + 3'd1;
                if(counter == 3'd7) begin   // 替換點做替換
                    if(arr[7] > arr[change_pt] && arr[7] < arr[min_pt]) begin
                        arr[change_pt] <= arr[7];
                        arr[7] <= arr[change_pt];
                    end
                    else begin
                        arr[change_pt] <= arr[min_pt];
                        arr[min_pt] <= arr[change_pt];
                    end
                end
                else begin   // 尋找最小點
                    if(arr[min_pt] < arr[change_pt])
                        min_pt <= counter + 3'd1;
                    else if(arr[counter + 3'd1] > arr[change_pt] && arr[min_pt] > arr[counter + 3'd1])
                        min_pt <= counter + 3'd1;
                end
            end
            Change: begin
                //for(i=1; i<=7-change_pt; i=i+1)
                //    arr[8-i] <= arr[change_pt+i];
                case (change_pt)
                    0: begin
                        for(i=1; i<=7; i=i+1)
                            arr[8-i] <= arr[0+i];
                    end
                    1: begin
                        for(i=1; i<=6; i=i+1)
                            arr[8-i] <= arr[1+i];
                    end
                    2: begin
                        for(i=1; i<=5; i=i+1)
                            arr[8-i] <= arr[2+i];
                    end
                    3: begin
                        for(i=1; i<=4; i=i+1)
                            arr[8-i] <= arr[3+i];
                    end
                    4: begin
                        for(i=1; i<=3; i=i+1)
                            arr[8-i] <= arr[4+i];
                    end
                    5: begin
                        for(i=1; i<=2; i=i+1)
                            arr[8-i] <= arr[5+i];
                    end
                endcase
                counter <= 3'd0;
                total <= total + 32'd1; 
            end
            Find: begin
                counter <= (counter == 3'd7) ? 3'd0 : counter + 3'd1;
                Cost_sum <= Cost_sum + Cost;
            end
            Cal: begin
                if(Cost_sum < MinCost) begin
                    MinCost <= Cost_sum;
                    MatchCount <= 4'd1;
                end
                else if(Cost_sum == MinCost)
                    MatchCount <= MatchCount + 4'd1;
                counter <= 3'd0;
                change_pt <= 3'd6;
                min_pt <= 3'd7;
            end
            Output: begin
                Valid <= 1'd1;
            end
        endcase
    end   
end

always @(*) begin
    case (cs)
        Find_pt: begin
            if(change_pt == 3'd0 && (arr[0] > arr[1]))
                ns = Output;
            else if(arr[change_pt] < arr[change_pt + 3'd1])
                ns = Find_min;
            else
                ns = Find_pt;
        end
        Find_min: ns = (counter == 3'd7) ? Change : Find_min;
        Change: ns = Find;
        Find: ns = (counter == 3'd7) ? Cal : Find;
        Cal: ns = Find_pt;
        default: ns = Output;
    endcase
end

endmodule


