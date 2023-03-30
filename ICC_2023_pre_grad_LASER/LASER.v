module LASER (
    input CLK,
    input RST,
    input [3:0] X,
    input [3:0] Y,
    output reg [3:0] C1X,
    output reg [3:0] C1Y,
    output reg [3:0] C2X,
    output reg [3:0] C2Y,
    output reg DONE
);

integer i;
parameter INPUT  = 0,
          WAIT   = 1,
          FIND   = 2,
          CHECK  = 3,
          OUTPUT = 4;

reg [2:0] cs, ns;
wire WAIT_signal = (cs == WAIT);
reg [7:0] counter;
reg [1:0] counter2;

reg [3:0] x_list[0:39], y_list[0:39];
reg [0:39] p1_list, p2_list;

reg [3:0] x, y, x1, y1, x2, y2, x_old, y_old;
reg [5:0] p1, p2, p, max_p, true_p2;

reg [3:0] abs_x[0:9], abs_y[0:9];

reg [0:9] half_list1, half_list2, half_list3, half_list4;



always @(posedge CLK) begin
    half_list1 <= half_list2;
    half_list2 <= half_list3;
    half_list3 <= half_list4;
end

// caculate point
always @(*) begin
    y = counter[7:4];
    x = counter[3:0];

    for(i=0;i<10;i=i+1) begin
        abs_x[i] = (x > x_list[i])? x - x_list[i] : x_list[i] - x;
        abs_y[i] = (y > y_list[i])? y - y_list[i] : y_list[i] - y;
        half_list4[i] = (abs_x[i] + abs_y[i] <= 4) || (abs_x[i] == 3 && abs_y[i] == 2) || (abs_x[i] == 2 && abs_y[i] == 3);
    end

    p = 0;
    for(i=0;i<10;i=i+1) begin
        p = (p2_list[i])? p : p + half_list1[i];
        p = (p2_list[i+10])? p : p + half_list2[i];
        p = (p2_list[i+20])? p : p + half_list3[i];
        p = (p2_list[i+30])? p : p + half_list4[i];
    end
        
    true_p2 = 0;
    for(i=0;i<40;i=i+1)
        true_p2 = (p1_list[i])? true_p2 + 1 : true_p2;
end

// x1, y1, x2, y2, p1, p2
always @(posedge CLK) begin
    case (cs)
        INPUT: begin
            x1 <= 0; y1 <= 0; p1 <= 0;
            x2 <= 0; y2 <= 0; p2 <= 0;
            x_old <= 0; y_old <= 0;
            p1_list <= 0; p2_list <= 0;
            max_p <= 0;
        end
        FIND: begin
            if(p >= p1) begin
                x1 <= x; y1 <= y; p1 <= p;
                p1_list <= {half_list1, half_list2, half_list3, half_list4};
            end
        end
        CHECK: begin
            max_p <= p1 + p2;
            p2_list <= p1_list;
            x1 <= 0; y1 <= 0; p1 <= 0;
            x2 <= x1; y2 <= y1; p2 <= true_p2;
            x_old <= x2; y_old <= y2;
        end
        OUTPUT: begin
            x1 <= 0; y1 <= 0; p1 <= 0;
            x2 <= 0; y2 <= 0; p2 <= 0;
            max_p <= 0;
        end
    endcase
end

// x, y list
always @(posedge CLK) begin
    if(cs == INPUT) begin
        x_list[0] <= X;
        y_list[0] <= Y;
        for(i=0;i<39;i=i+1) begin
            x_list[i+1] <= x_list[i];
            y_list[i+1] <= y_list[i];
        end
    end
    else if(cs == FIND || WAIT_signal) begin
        for(i=0;i<10;i=i+1) begin
            x_list[i] <= x_list[i+10];
            x_list[i+10] <= x_list[i+20];
            x_list[i+20] <= x_list[i+30];
            x_list[i+30] <= x_list[i];
            y_list[i]    <= y_list[i+10];
            y_list[i+10] <= y_list[i+20];
            y_list[i+20] <= y_list[i+30];
            y_list[i+30] <= y_list[i];
        end
    end
end

// Counter
always @(posedge CLK or posedge RST) begin
    if(RST) counter <= 0;
    else begin
        case (cs)
            INPUT: counter <= (counter == 39)? 0 : counter + 1;
            FIND:begin
                if(counter[3:0]==12)begin
                    counter <= (y==0)? counter + 32:(y==2)? counter + 46:(y==7)? counter + 39 : counter + 4;
                end
                else begin
                    counter <= (counter[3:0] == 0 || counter[3:0] == 6)? counter + 3 : counter + 1;
                end
            end
            WAIT: counter <= counter;
            default: counter <= 0;
        endcase
    end
end

always @(posedge CLK or posedge RST) begin
    if(RST) counter2 <= 0;
    else  counter2 <= (WAIT_signal)? counter2 + 1 : 0;
end

// Output
always @(*) begin
    DONE = (cs == OUTPUT);
end
always @(posedge CLK or posedge RST) begin
    if(RST) begin
        C1X <= 0; C1Y <= 0;
        C2X <= 0; C2Y <= 0;
    end
    else begin
        if(cs == CHECK) begin
            C1X <= x1; C1Y <= y1;
            C2X <= x2; C2Y <= y2;
        end
    end
end

// FSM
always @(*) begin
    case (cs)
        INPUT: ns = (counter == 39)? WAIT : cs;
        WAIT: ns = (counter2 == 2)? FIND : WAIT;
        FIND: ns = (counter == 192)? CHECK : WAIT;
        CHECK: ns = (x1 == x_old && y1 == y_old)? OUTPUT : WAIT;
        OUTPUT: ns = INPUT;
        default: ns = INPUT;
    endcase
end

always @(posedge CLK or posedge RST) begin
    cs <= (RST)? INPUT : ns;
end

endmodule