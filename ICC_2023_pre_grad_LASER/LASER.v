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
reg [7:0] counter;
reg [1:0] counter2;

reg [3:0] x_list[0:39], y_list[0:39]; // Store 40 dot coordinate
reg [0:39] p1_list, p2_list; // Store which dot are chosen by circle_1 and circle_2

 // xy: scan circle, x1y1: best circle in scanning, x2y2: fixed circle, x_old y_old: check if result converged
reg [3:0] x, y, x1, y1, x2, y2, x_old, y_old;
reg [5:0] p1, p2, p, max_p, true_p1; // Store how many dot are covered

reg [3:0] abs_x[0:9], abs_y[0:9];

reg [0:9] quarter_list[0:3];


wire WAIT_signal = (cs == WAIT); // Reduce combinational area

always @(posedge CLK) begin
    quarter_list[0] <= quarter_list[1];
    quarter_list[1] <= quarter_list[2];
    quarter_list[2] <= quarter_list[3];
end

// caculate point
always @(*) begin
    // caculate if dot is in circlue   abs(x - circle_x) + abs(y - circle_y) <= 4 
    //                              or (abs(x - circle_x), abs(y - circle_y)) == (3, 2) or (2, 3)
    // only caculate 10 dot at once limited to area
    for(i=0;i<10;i=i+1) begin
        abs_x[i] = (x > x_list[i])? x - x_list[i] : x_list[i] - x;
        abs_y[i] = (y > y_list[i])? y - y_list[i] : y_list[i] - y;
        quarter_list[3][i] = (abs_x[i] + abs_y[i] <= 4) || (abs_x[i] == 3 && abs_y[i] == 2) || (abs_x[i] == 2 && abs_y[i] == 3);
    end

    // caculate how many dots are in circle_1 (p2 is the dots covered by circle_2 (fixed))
    // if dot is covered by circlue_2, we don't count it toward the total.
    p = 0;
    for(i=0;i<10;i=i+1) begin
        p = (p2_list[i])? p : p + quarter_list[0][i];
        p = (p2_list[i+10])? p : p + quarter_list[1][i];
        p = (p2_list[i+20])? p : p + quarter_list[2][i];
        p = (p2_list[i+30])? p : p + quarter_list[3][i];
    end
    
    // true_p1 is how many dots are covered by circle 1 (didn't care about circle_2 (fixed))
    true_p1 = 0;
    for(i=0;i<40;i=i+1)
        true_p1 = (p1_list[i])? true_p1 + 1 : true_p1;
end

// x, y
always @(*) begin
    // convert counter to xy coordinate
    y = counter[7:4];
    x = counter[3:0];
end

// x1, y1, x2, y2, p1, p2
// xy: coordinate
// p: how many dots are covered
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
            if(p >= p1) begin // update if the covered dots are more than previous
                x1 <= x; y1 <= y; p1 <= p;
                p1_list <= {quarter_list[0], quarter_list[1], quarter_list[2], quarter_list[3]};
            end
        end
        CHECK: begin // fixed this circle and turn to scan another circle, check if result is converged
            max_p <= p1 + p2;
            p2_list <= p1_list;
            x1 <= 0; y1 <= 0; p1 <= 0;
            x2 <= x1; y2 <= y1; p2 <= true_p1; // we need true p1 that didn't care about whether it covered by another circle
            x_old <= x2; y_old <= y2;
        end
        OUTPUT: begin
            x1 <= 0; y1 <= 0; p1 <= 0;
            x2 <= 0; y2 <= 0; p2 <= 0;
            max_p <= 0;
        end
    endcase
end

// input
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
        for(i=0;i<10;i=i+1) begin // use shift register to reduce area
            x_list[i]    <= x_list[i+10];    y_list[i]    <= y_list[i+10];
            x_list[i+10] <= x_list[i+20];    y_list[i+10] <= y_list[i+20];
            x_list[i+20] <= x_list[i+30];    y_list[i+20] <= y_list[i+30];
            x_list[i+30] <= x_list[i];       y_list[i+30] <= y_list[i];
        end
    end
end

// Counter
always @(posedge CLK or posedge RST) begin
    if(RST) counter <= 0;
    else begin
        case (cs)
            INPUT: counter <= (counter == 39)? 0 : counter + 1; // store 40 input
            FIND:begin // special xy scanning path
                if(counter[3:0]==12)
                    counter <= (y==0)? counter + 32:(y==2)? counter + 46:(y==7)? counter + 39 : counter + 4;
                else 
                    counter <= (counter[3:0] == 0 || counter[3:0] == 6)? counter + 3 : counter + 1;
            end
            // normal xy scanning path
            // FIND: counter <= (counter == 255)? 0 : counter + 1;
            WAIT: counter <= counter;
            default: counter <= 0;
        endcase
    end
end

// Counter2  (we need to caculate 4 times for 40 dots (each time for 10 dots))
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
        WAIT: ns = (counter2 == 2)? FIND : WAIT; // wait for caculate 4 times (3 in WAIT, 1 in FIND)
        FIND: ns = (counter == 192)? CHECK : WAIT; // special xy scanning path
        // FIND: ns = (counter == 255)? CHECK : WAIT // normal xy scanning path
        CHECK: ns = (x1 == x_old && y1 == y_old)? OUTPUT : WAIT; // check if result is converged
        OUTPUT: ns = INPUT;
        default: ns = INPUT;
    endcase
end

always @(posedge CLK or posedge RST) begin
    cs <= (RST)? INPUT : ns;
end

endmodule