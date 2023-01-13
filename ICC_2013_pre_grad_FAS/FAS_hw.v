module  FAS (data_valid, data, clk, rst, fir_d, fir_valid, fft_valid, done, freq,
 fft_d1, fft_d2, fft_d3, fft_d4, fft_d5, fft_d6, fft_d7, fft_d8,
 fft_d9, fft_d10, fft_d11, fft_d12, fft_d13, fft_d14, fft_d15, fft_d0);
input clk, rst;
input data_valid;
input [15:0] data; 

output reg fir_valid, fft_valid;
output reg [15:0] fir_d;
output reg [31:0] fft_d1, fft_d2, fft_d3, fft_d4, fft_d5, fft_d6, fft_d7, fft_d8;
output reg [31:0] fft_d9, fft_d10, fft_d11, fft_d12, fft_d13, fft_d14, fft_d15, fft_d0;
output reg done;
output reg [3:0] freq;

integer i;
reg [4:0] count;
reg [2:0] current_state, next_state;
reg signed [35:0] fir [31:0];
reg signed [35:0] fir_out1,fir_out2,fir_out3,fir_out4,fir_out;
reg signed [15:0] fir_data[31:0];
reg signed [15:0] reg_data[15:0];
reg signed [15:0] fft_data[15:0];
reg signed [19:0] fft_real_1[15:0],fft_real_2[15:0],fft_real_3[15:0]; // 4 int + 16 float
reg signed [19:0] fft_imag_1[15:0],fft_imag_2[15:0],fft_imag_3[15:0]; // 4 int + 16 float 
reg signed [15:0] fft_imag_4[15:0],fft_real_4[15:0]; // 最後答案 8 int + 8 float 
reg signed [39:0] real_1[15:0], real_2[15:0], real_3[15:0], real_4[15:0]; // 4 int + 16 float * 4 int + 16 float = 40 bits
reg signed [39:0] imag_1[15:0], imag_2[15:0], imag_3[15:0], imag_4[15:0]; // 4 int + 16 float * 4 int + 16 float = 40 bits
reg signed [31:0] freq_data[15:0],freq1,freq2;
reg [3:0] max_index;

parameter signed [19:0] FIR_C00 = 20'hFFF9E ;     //The FIR_coefficient value 0: -1.495361e-003
parameter signed [19:0] FIR_C01 = 20'hFFF86 ;     //The FIR_coefficient value 1: -1.861572e-003
parameter signed [19:0] FIR_C02 = 20'hFFFA7 ;     //The FIR_coefficient value 2: -1.358032e-003
parameter signed [19:0] FIR_C03 = 20'h0003B ;    //The FIR_coefficient value 3: 9.002686e-004
parameter signed [19:0] FIR_C04 = 20'h0014B ;    //The FIR_coefficient value 4: 5.050659e-003
parameter signed [19:0] FIR_C05 = 20'h0024A ;    //The FIR_coefficient value 5: 8.941650e-003
parameter signed [19:0] FIR_C06 = 20'h00222 ;    //The FIR_coefficient value 6: 8.331299e-003
parameter signed [19:0] FIR_C07 = 20'hFFFE4 ;     //The FIR_coefficient value 7: -4.272461e-004
parameter signed [19:0] FIR_C08 = 20'hFFBC5 ;     //The FIR_coefficient value 8: -1.652527e-002
parameter signed [19:0] FIR_C09 = 20'hFF7CA ;     //The FIR_coefficient value 9: -3.207397e-002
parameter signed [19:0] FIR_C10 = 20'hFF74E ;     //The FIR_coefficient value 10: -3.396606e-002
parameter signed [19:0] FIR_C11 = 20'hFFD74 ;     //The FIR_coefficient value 11: -9.948730e-003
parameter signed [19:0] FIR_C12 = 20'h00B1A ;    //The FIR_coefficient value 12: 4.336548e-002
parameter signed [19:0] FIR_C13 = 20'h01DAC ;    //The FIR_coefficient value 13: 1.159058e-001
parameter signed [19:0] FIR_C14 = 20'h02F9E ;    //The FIR_coefficient value 14: 1.860046e-001
parameter signed [19:0] FIR_C15 = 20'h03AA9 ;    //The FIR_coefficient value 15: 2.291412e-001
parameter signed [19:0] FIR_C16 = 20'h03AA9 ;    //The FIR_coefficient value 16: 2.291412e-001
parameter signed [19:0] FIR_C17 = 20'h02F9E ;    //The FIR_coefficient value 17: 1.860046e-001
parameter signed [19:0] FIR_C18 = 20'h01DAC ;    //The FIR_coefficient value 18: 1.159058e-001
parameter signed [19:0] FIR_C19 = 20'h00B1A ;    //The FIR_coefficient value 19: 4.336548e-002
parameter signed [19:0] FIR_C20 = 20'hFFD74 ;     //The FIR_coefficient value 20: -9.948730e-003
parameter signed [19:0] FIR_C21 = 20'hFF74E ;     //The FIR_coefficient value 21: -3.396606e-002
parameter signed [19:0] FIR_C22 = 20'hFF7CA ;     //The FIR_coefficient value 22: -3.207397e-002
parameter signed [19:0] FIR_C23 = 20'hFFBC5 ;     //The FIR_coefficient value 23: -1.652527e-002
parameter signed [19:0] FIR_C24 = 20'hFFFE4 ;     //The FIR_coefficient value 24: -4.272461e-004
parameter signed [19:0] FIR_C25 = 20'h00222 ;    //The FIR_coefficient value 25: 8.331299e-003
parameter signed [19:0] FIR_C26 = 20'h0024A ;    //The FIR_coefficient value 26: 8.941650e-003
parameter signed [19:0] FIR_C27 = 20'h0014B ;    //The FIR_coefficient value 27: 5.050659e-003
parameter signed [19:0] FIR_C28 = 20'h0003B ;    //The FIR_coefficient value 28: 9.002686e-004
parameter signed [19:0] FIR_C29 = 20'hFFFA7 ;     //The FIR_coefficient value 29: -1.358032e-003
parameter signed [19:0] FIR_C30 = 20'hFFF86 ;     //The FIR_coefficient value 30: -1.861572e-003
parameter signed [19:0] FIR_C31 = 20'hFFF9E ;     //The FIR_coefficient value 31: -1.495361e-003

parameter signed [19:0] w_real_0 = 20'h10000 ;     //The real part of the reference table about COS(x)+i*SIN(x) value , 0: 001
parameter signed [19:0] w_real_1 = 20'h0EC83 ;     //The real part of the reference table about COS(x)+i*SIN(x) value , 1: 9.238739e-001
parameter signed [19:0] w_real_2 = 20'h0B504 ;     //The real part of the reference table about COS(x)+i*SIN(x) value , 2: 7.070923e-001
parameter signed [19:0] w_real_3 = 20'h061F7 ;     //The real part of the reference table about COS(x)+i*SIN(x) value , 3: 3.826752e-001
parameter signed [19:0] w_real_4 = 20'h00000 ;     //The real part of the reference table about COS(x)+i*SIN(x) value , 4: 000
parameter signed [19:0] w_real_5 = 20'hF9E09 ;     //The real part of the reference table about COS(x)+i*SIN(x) value , 5: -3.826752e-001
parameter signed [19:0] w_real_6 = 20'hF4AFC ;     //The real part of the reference table about COS(x)+i*SIN(x) value , 6: -7.070923e-001
parameter signed [19:0] w_real_7 = 20'hF137D ;     //The real part of the reference table about COS(x)+i*SIN(x) value , 7: -9.238739e-001

parameter signed [19:0] w_imag_0 = 20'h00000 ;     //The imag part of the reference table about COS(x)+i*SIN(x) value , 0: 000
parameter signed [19:0] w_imag_1 = 20'hF9E09 ;     //The imag part of the reference table about COS(x)+i*SIN(x) value , 1: -3.826752e-001
parameter signed [19:0] w_imag_2 = 20'hF4AFC ;     //The imag part of the reference table about COS(x)+i*SIN(x) value , 2: -7.070923e-001
parameter signed [19:0] w_imag_3 = 20'hF137D ;     //The imag part of the reference table about COS(x)+i*SIN(x) value , 3: -9.238739e-001
parameter signed [19:0] w_imag_4 = 20'hF0000 ;     //The imag part of the reference table about COS(x)+i*SIN(x) value , 4: -01
parameter signed [19:0] w_imag_5 = 20'hF137D ;     //The imag part of the reference table about COS(x)+i*SIN(x) value , 5: -9.238739e-001
parameter signed [19:0] w_imag_6 = 20'hF4AFC ;     //The imag part of the reference table about COS(x)+i*SIN(x) value , 6: -7.070923e-001
parameter signed [19:0] w_imag_7 = 20'hF9E09 ;     //The imag part of the reference table about COS(x)+i*SIN(x) value , 7: -3.826752e-001



always @( posedge clk or posedge rst ) begin // Analysis
    if( rst ) begin
        done <= 0;
    end
    else begin
        if( current_state == 4) begin
            case (count)
                15: begin
                    done <= 1;
                    max_index <= 0;
                    freq <= max_index;
                    for(i=0;i<16;i=i+1) begin
                        fft_real_4[i] <= {real_4[i][39], real_4[i][38:24]} ;
                        fft_imag_4[i] <= {imag_4[i][39], imag_4[i][38:24]} ;
                    end
                end
                default: begin // Bubble Sort
                    done <= 0;
                    freq1 = fft_real_4[ count ]*fft_real_4[ count ] + fft_imag_4[ count ]*fft_imag_4[ count ];
                    freq2 = fft_real_4[ count+1 ]*fft_real_4[ count+1 ] + fft_imag_4[ count+1 ]*fft_imag_4[ count+1 ];
                    if( freq1 > freq2 ) begin
                        fft_real_4[ count+1 ] <= fft_real_4[ count ];
                        fft_imag_4[ count+1 ] <= fft_imag_4[ count ];
                    end
                    else
                        max_index <= count+1;
                end
            endcase
        end
        else begin // 準備第一個FFT
            max_index <= 0;
            for(i=0;i<16;i=i+1) begin
                fft_real_4[i] <= {real_4[i][39], real_4[i][38:24]} ;
                fft_imag_4[i] <= {imag_4[i][39], imag_4[i][38:24]} ;
            end 
        end
    end
end

always @( * ) begin
    // A: a + bj
    // B: c + dj
    // Real: (a-c) << 16 + (d-b) << 16
    // Imag: (a-c) << 16 + (b-d) << 16
    // FFT_1
    real_1[0]  <= ( fft_data[0]  + fft_data[8] ) << 16;    imag_1[0] <= 0;
    real_1[1]  <= ( fft_data[1]  + fft_data[9] ) << 16;    imag_1[1] <= 0;
    real_1[2]  <= ( fft_data[2]  + fft_data[10] ) << 16;   imag_1[2] <= 0;
    real_1[3]  <= ( fft_data[3]  + fft_data[11] ) << 16;   imag_1[3] <= 0;
    real_1[4]  <= ( fft_data[4]  + fft_data[12] ) << 16;   imag_1[4] <= 0;
    real_1[5]  <= ( fft_data[5]  + fft_data[13] ) << 16;   imag_1[5] <= 0;
    real_1[6]  <= ( fft_data[6]  + fft_data[14] ) << 16;   imag_1[6] <= 0;
    real_1[7]  <= ( fft_data[7]  + fft_data[15] ) << 16;   imag_1[7] <= 0;
    real_1[8]  <= ( fft_data[0]  - fft_data[8] )*w_real_0;
    imag_1[8]  <= ( fft_data[0]  - fft_data[8] )*w_imag_0;
    real_1[9]  <= ( fft_data[1]  - fft_data[9] )*w_real_1;
    imag_1[9]  <= ( fft_data[1]  - fft_data[9] )*w_imag_1;
    real_1[10] <= ( fft_data[2] - fft_data[10] )*w_real_2;
    imag_1[10] <= ( fft_data[2] - fft_data[10] )*w_imag_2;
    real_1[11] <= ( fft_data[3] - fft_data[11] )*w_real_3;
    imag_1[11] <= ( fft_data[3] - fft_data[11] )*w_imag_3;
    real_1[12] <= ( fft_data[4] - fft_data[12] )*w_real_4;
    imag_1[12] <= ( fft_data[4] - fft_data[12] )*w_imag_4;
    real_1[13] <= ( fft_data[5] - fft_data[13] )*w_real_5;
    imag_1[13] <= ( fft_data[5] - fft_data[13] )*w_imag_5;
    real_1[14] <= ( fft_data[6] - fft_data[14] )*w_real_6;
    imag_1[14] <= ( fft_data[6] - fft_data[14] )*w_imag_6;
    real_1[15] <= ( fft_data[7] - fft_data[15] )*w_real_7;
    imag_1[15] <= ( fft_data[7] - fft_data[15] )*w_imag_7; 
    for(i=0;i<16;i=i+1) begin
        fft_real_1[i] <= {real_1[i][39], real_1[i][26:8]} ;
        fft_imag_1[i] <= {imag_1[i][39], imag_1[i][26:8]} ;
    end

    // FFT_2
    real_2[15] <= ( fft_real_1[11] - fft_real_1[15] )*w_real_6 + ( fft_imag_1[15] - fft_imag_1[11] )*w_imag_6 ;
    imag_2[15] <= ( fft_real_1[11] - fft_real_1[15] )*w_imag_6 - ( fft_imag_1[15] - fft_imag_1[11] )*w_real_6 ;
    real_2[14] <= ( fft_real_1[10] - fft_real_1[14] )*w_real_4 + ( fft_imag_1[14] - fft_imag_1[10] )*w_imag_4 ;
    imag_2[14] <= ( fft_real_1[10] - fft_real_1[14] )*w_imag_4 - ( fft_imag_1[14] - fft_imag_1[10] )*w_real_4 ;
    real_2[13] <= ( fft_real_1[9] - fft_real_1[13] )*w_real_2  + ( fft_imag_1[13] - fft_imag_1[9] )*w_imag_2 ;
    imag_2[13] <= ( fft_real_1[9] - fft_real_1[13] )*w_imag_2  - ( fft_imag_1[13] - fft_imag_1[9] )*w_real_2 ;
    real_2[12] <= ( fft_real_1[8] - fft_real_1[12] )*w_real_0  + ( fft_imag_1[12] - fft_imag_1[8] )*w_imag_0 ;
    imag_2[12] <= ( fft_real_1[8] - fft_real_1[12] )*w_imag_0  - ( fft_imag_1[12] - fft_imag_1[8] )*w_real_0 ;
    real_2[11] <= ( fft_real_1[11] + fft_real_1[15] ) << 16 ;
    imag_2[11] <= ( fft_imag_1[11] + fft_imag_1[15] ) << 16 ;
    real_2[10] <= ( fft_real_1[10] + fft_real_1[14] ) << 16 ;
    imag_2[10] <= ( fft_imag_1[10] + fft_imag_1[14] ) << 16 ;
    real_2[9]  <= ( fft_real_1[9]  + fft_real_1[13] ) << 16 ;
    imag_2[9]  <= ( fft_imag_1[9]  + fft_imag_1[13] ) << 16 ;
    real_2[8]  <= ( fft_real_1[8]  + fft_real_1[12] ) << 16 ;
    imag_2[8]  <= ( fft_imag_1[8]  + fft_imag_1[12] ) << 16 ;

    real_2[7] <= ( fft_real_1[3] - fft_real_1[7] )*w_real_6 + ( fft_imag_1[7] - fft_imag_1[3] )*w_imag_6 ;
    imag_2[7] <= ( fft_real_1[3] - fft_real_1[7] )*w_imag_6 - ( fft_imag_1[7] - fft_imag_1[3] )*w_real_6 ;
    real_2[6] <= ( fft_real_1[2] - fft_real_1[6] )*w_real_4 + ( fft_imag_1[6] - fft_imag_1[2] )*w_imag_4 ;
    imag_2[6] <= ( fft_real_1[2] - fft_real_1[6] )*w_imag_4 - ( fft_imag_1[6] - fft_imag_1[2] )*w_real_4 ;
    real_2[5] <= ( fft_real_1[1] - fft_real_1[5] )*w_real_2 + ( fft_imag_1[5] - fft_imag_1[1] )*w_imag_2 ;
    imag_2[5] <= ( fft_real_1[1] - fft_real_1[5] )*w_imag_2 - ( fft_imag_1[5] - fft_imag_1[1] )*w_real_2 ;
    real_2[4] <= ( fft_real_1[0] - fft_real_1[4] )*w_real_0 + ( fft_imag_1[4] - fft_imag_1[0] )*w_imag_0 ;
    imag_2[4] <= ( fft_real_1[0] - fft_real_1[4] )*w_imag_0 - ( fft_imag_1[4] - fft_imag_1[0] )*w_real_0 ;
    real_2[3] <= ( fft_real_1[3] + fft_real_1[7] ) << 16  ;
    imag_2[3] <= ( fft_imag_1[3] + fft_imag_1[7] ) << 16  ;
    real_2[2] <= ( fft_real_1[2] + fft_real_1[6] ) << 16  ;
    imag_2[2] <= ( fft_imag_1[2] + fft_imag_1[6] ) << 16  ;
    real_2[1] <= ( fft_real_1[1] + fft_real_1[5] ) << 16  ;
    imag_2[1] <= ( fft_imag_1[1] + fft_imag_1[5] ) << 16  ;
    real_2[0] <= ( fft_real_1[0] + fft_real_1[4] ) << 16  ;
    imag_2[0] <= ( fft_imag_1[0] + fft_imag_1[4] ) << 16  ;

    for(i=0;i<16;i=i+1) begin
        fft_real_2[i] <= {real_2[i][39], real_2[i][34:16]} ;
        fft_imag_2[i] <= {imag_2[i][39], imag_2[i][34:16]} ;
    end

    // FFT_3
    real_3[15] <= ( fft_real_2[13] - fft_real_2[15] )*w_real_4 + ( fft_imag_2[15] - fft_imag_2[13] )*w_imag_4 ;
    imag_3[15] <= ( fft_real_2[13] - fft_real_2[15] )*w_imag_4 - ( fft_imag_2[15] - fft_imag_2[13] )*w_real_4 ;
    real_3[14] <= ( fft_real_2[12] - fft_real_2[14] )*w_real_0 + ( fft_imag_2[14] - fft_imag_2[12] )*w_imag_0 ;
    imag_3[14] <= ( fft_real_2[12] - fft_real_2[14] )*w_imag_0 - ( fft_imag_2[14] - fft_imag_2[12] )*w_real_0 ;
    real_3[13] <= ( fft_real_2[13] + fft_real_2[15] ) << 16  ;
    imag_3[13] <= ( fft_imag_2[13] + fft_imag_2[15] ) << 16  ;
    real_3[12] <= ( fft_real_2[12] + fft_real_2[14] ) << 16  ;
    imag_3[12] <= ( fft_imag_2[12] + fft_imag_2[14] ) << 16  ;

    real_3[11] <= ( fft_real_2[9] - fft_real_2[11] )*w_real_4 + ( fft_imag_2[11] - fft_imag_2[9] )*w_imag_4 ;
    imag_3[11] <= ( fft_real_2[9] - fft_real_2[11] )*w_imag_4 - ( fft_imag_2[11] - fft_imag_2[9] )*w_real_4 ;
    real_3[10] <= ( fft_real_2[8] - fft_real_2[10] )*w_real_0 + ( fft_imag_2[10] - fft_imag_2[8] )*w_imag_0 ;
    imag_3[10] <= ( fft_real_2[8] - fft_real_2[10] )*w_imag_0 - ( fft_imag_2[10] - fft_imag_2[8] )*w_real_0 ;
    real_3[9]  <= ( fft_real_2[9] + fft_real_2[11] ) << 16  ;
    imag_3[9]  <= ( fft_imag_2[9] + fft_imag_2[11] ) << 16  ;
    real_3[8]  <= ( fft_real_2[8] + fft_real_2[10] ) << 16  ;
    imag_3[8]  <= ( fft_imag_2[8] + fft_imag_2[10] ) << 16  ;

    real_3[7] <= ( fft_real_2[5] - fft_real_2[7] )*w_real_4 + ( fft_imag_2[7] - fft_imag_2[5] )*w_imag_4 ;
    imag_3[7] <= ( fft_real_2[5] - fft_real_2[7] )*w_imag_4 - ( fft_imag_2[7] - fft_imag_2[5] )*w_real_4 ;
    real_3[6] <= ( fft_real_2[4] - fft_real_2[6] )*w_real_0 + ( fft_imag_2[6] - fft_imag_2[4] )*w_imag_0 ;
    imag_3[6] <= ( fft_real_2[4] - fft_real_2[6] )*w_imag_0 - ( fft_imag_2[6] - fft_imag_2[4] )*w_real_0 ;
    real_3[5] <= ( fft_real_2[5] + fft_real_2[7] ) << 16  ;
    imag_3[5] <= ( fft_imag_2[5] + fft_imag_2[7] ) << 16  ;
    real_3[4] <= ( fft_real_2[4] + fft_real_2[6] ) << 16  ;
    imag_3[4] <= ( fft_imag_2[4] + fft_imag_2[6] ) << 16  ;

    real_3[3] <= ( fft_real_2[1] - fft_real_2[3] )*w_real_4 + ( fft_imag_2[3] - fft_imag_2[1] )*w_imag_4 ;
    imag_3[3] <= ( fft_real_2[1] - fft_real_2[3] )*w_imag_4 - ( fft_imag_2[3] - fft_imag_2[1] )*w_real_4 ;
    real_3[2] <= ( fft_real_2[0] - fft_real_2[2] )*w_real_0 + ( fft_imag_2[2] - fft_imag_2[0] )*w_imag_0 ;
    imag_3[2] <= ( fft_real_2[0] - fft_real_2[2] )*w_imag_0 - ( fft_imag_2[2] - fft_imag_2[0] )*w_real_0 ;
    real_3[1] <= ( fft_real_2[1] + fft_real_2[3] ) << 16  ;
    imag_3[1] <= ( fft_imag_2[1] + fft_imag_2[3] ) << 16  ;
    real_3[0] <= ( fft_real_2[0] + fft_real_2[2] ) << 16  ;
    imag_3[0] <= ( fft_imag_2[0] + fft_imag_2[2] ) << 16  ;

    for(i=0;i<16;i=i+1) begin
        fft_real_3[i] <= {real_3[i][39], real_3[i][34:16]} ;
        fft_imag_3[i] <= {imag_3[i][39], imag_3[i][34:16]} ;
    end

    // FFT_4
    real_4[15] <= ( fft_real_3[14] - fft_real_3[15] )*w_real_0 + ( fft_imag_3[15] - fft_imag_3[14] )*w_imag_0 ;
    imag_4[15] <= ( fft_real_3[14] - fft_real_3[15] )*w_imag_0 - ( fft_imag_3[15] - fft_imag_3[14] )*w_real_0 ;
    real_4[7] <= ( fft_real_3[14] + fft_real_3[15] ) << 16 ;
    imag_4[7] <= ( fft_imag_3[14] + fft_imag_3[15] ) << 16 ;

    real_4[11] <= ( fft_real_3[12] - fft_real_3[13] )*w_real_0 + ( fft_imag_3[13] - fft_imag_3[12] )*w_imag_0 ;
    imag_4[11] <= ( fft_real_3[12] - fft_real_3[13] )*w_imag_0 - ( fft_imag_3[13] - fft_imag_3[12] )*w_real_0 ;
    real_4[3] <= ( fft_real_3[12] + fft_real_3[13] ) << 16 ;
    imag_4[3] <= ( fft_imag_3[12] + fft_imag_3[13] ) << 16 ;

    real_4[13] <= ( fft_real_3[10] - fft_real_3[11] )*w_real_0 + ( fft_imag_3[11] - fft_imag_3[10] )*w_imag_0 ;
    imag_4[13] <= ( fft_real_3[10] - fft_real_3[11] )*w_imag_0 - ( fft_imag_3[11] - fft_imag_3[10] )*w_real_0 ;
    real_4[5] <= ( fft_real_3[10] + fft_real_3[11] ) << 16 ;
    imag_4[5] <= ( fft_imag_3[10] + fft_imag_3[11] ) << 16 ;
    
    real_4[9]  <= ( fft_real_3[8] - fft_real_3[9] )*w_real_0 + ( fft_imag_3[9] - fft_imag_3[8] )*w_imag_0 ;
    imag_4[9]  <= ( fft_real_3[8] - fft_real_3[9] )*w_imag_0 - ( fft_imag_3[9] - fft_imag_3[8] )*w_real_0 ;
    real_4[1]  <= ( fft_real_3[8] + fft_real_3[9] ) << 16 ;
    imag_4[1]  <= ( fft_imag_3[8] + fft_imag_3[9] ) << 16 ;

    real_4[14]  <= ( fft_real_3[6] - fft_real_3[7] )*w_real_0 + ( fft_imag_3[7] - fft_imag_3[6] )*w_imag_0 ;
    imag_4[14]  <= ( fft_real_3[6] - fft_real_3[7] )*w_imag_0 - ( fft_imag_3[7] - fft_imag_3[6] )*w_real_0 ;
    real_4[6]  <= ( fft_real_3[6] + fft_real_3[7] ) << 16 ;
    imag_4[6]  <= ( fft_imag_3[6] + fft_imag_3[7] ) << 16 ;

    real_4[10]  <= ( fft_real_3[4] - fft_real_3[5] )*w_real_0 + ( fft_imag_3[5] - fft_imag_3[4] )*w_imag_0 ;
    imag_4[10]  <= ( fft_real_3[4] - fft_real_3[5] )*w_imag_0 - ( fft_imag_3[5] - fft_imag_3[4] )*w_real_0 ;
    real_4[2]  <= ( fft_real_3[4] + fft_real_3[5] ) << 16 ;
    imag_4[2]  <= ( fft_imag_3[4] + fft_imag_3[5] ) << 16 ;

    real_4[12]  <= ( fft_real_3[2] - fft_real_3[3] )*w_real_0 + ( fft_imag_3[3] - fft_imag_3[2] )*w_imag_0 ;
    imag_4[12]  <= ( fft_real_3[2] - fft_real_3[3] )*w_imag_0 - ( fft_imag_3[3] - fft_imag_3[2] )*w_real_0 ;
    real_4[4]  <= ( fft_real_3[2] + fft_real_3[3] ) << 16 ;
    imag_4[4]  <= ( fft_imag_3[2] + fft_imag_3[3] ) << 16 ;

    real_4[8]  <= ( fft_real_3[0] - fft_real_3[1] )*w_real_0 + ( fft_imag_3[1] - fft_imag_3[0] )*w_imag_0 ;
    imag_4[8]  <= ( fft_real_3[0] - fft_real_3[1] )*w_imag_0 - ( fft_imag_3[1] - fft_imag_3[0] )*w_real_0 ;
    real_4[0]  <= ( fft_real_3[0] + fft_real_3[1] ) << 16 ;
    imag_4[0]  <= ( fft_imag_3[0] + fft_imag_3[1] ) << 16 ;

end

always @( posedge clk or posedge rst ) begin // FFT
    if( rst ) begin
        fft_valid <= 0;
    end
    else begin
        if( current_state >= 3) begin
            case (count)
                0: begin
                    fft_valid <= 0;
                    for(i=0;i<16;i=i+1)
                        fft_data[i] <= reg_data[i];
                end 
                15: begin //FFT輸出
                    fft_valid <= 1;
                    fft_d15 <= {real_4[15][39], real_4[15][38:24], imag_4[15][39], imag_4[15][38:24]};
                    fft_d14  <= {real_4[14][39], real_4[14][38:24], imag_4[14][39], imag_4[14][38:24]};
                    fft_d13 <= {real_4[13][39], real_4[13][38:24], imag_4[13][39], imag_4[13][38:24]};
                    fft_d12  <= {real_4[12][39], real_4[12][38:24], imag_4[12][39], imag_4[12][38:24]};
                    fft_d11 <= {real_4[11][39], real_4[11][38:24], imag_4[11][39], imag_4[11][38:24]};
                    fft_d10  <= {real_4[10][39], real_4[10][38:24], imag_4[10][39], imag_4[10][38:24]};
                    fft_d9  <= {real_4[9][39],  real_4[9][38:24],  imag_4[9][39],  imag_4[9][38:24]};
                    fft_d8  <= {real_4[8][39],  real_4[8][38:24],  imag_4[8][39],  imag_4[8][38:24]};
                    fft_d7 <= {real_4[7][39],  real_4[7][38:24],  imag_4[7][39],  imag_4[7][38:24]};
                    fft_d6  <= {real_4[6][39],  real_4[6][38:24],  imag_4[6][39],  imag_4[6][38:24]};
                    fft_d5 <= {real_4[5][39],  real_4[5][38:24],  imag_4[5][39],  imag_4[5][38:24]};
                    fft_d4  <= {real_4[4][39],  real_4[4][38:24],  imag_4[4][39],  imag_4[4][38:24]};
                    fft_d3 <= {real_4[3][39],  real_4[3][38:24],  imag_4[3][39],  imag_4[3][38:24]};
                    fft_d2  <= {real_4[2][39],  real_4[2][38:24],  imag_4[2][39],  imag_4[2][38:24]};
                    fft_d1  <= {real_4[1][39],  real_4[1][38:24],  imag_4[1][39],  imag_4[1][38:24]};
                    fft_d0  <= {real_4[0][39],  real_4[0][38:24],  imag_4[0][39],  imag_4[0][38:24]};
                end
                default: ;
            endcase
        end
    end
end


always @( * ) begin // fir運算
    fir[0]  = fir_data[0]*FIR_C00;    fir[1] = fir_data[1]*FIR_C01;     fir[2] = fir_data[2]*FIR_C02;     fir[3] = fir_data[3]*FIR_C03;
    fir[4]  = fir_data[4]*FIR_C04;    fir[5] = fir_data[5]*FIR_C05;     fir[6] = fir_data[6]*FIR_C06;     fir[7] = fir_data[7]*FIR_C07;
    fir[8]  = fir_data[8]*FIR_C08;    fir[9] = fir_data[9]*FIR_C09;     fir[10] = fir_data[10]*FIR_C10;   fir[11] = fir_data[11]*FIR_C11;
    fir[12] = fir_data[12]*FIR_C12;   fir[13] = fir_data[13]*FIR_C13;   fir[14] = fir_data[14]*FIR_C14;   fir[15] = fir_data[15]*FIR_C15;
    fir[16] = fir_data[16]*FIR_C16;   fir[17] = fir_data[17]*FIR_C17;   fir[18] = fir_data[18]*FIR_C18;   fir[19] = fir_data[19]*FIR_C19;
    fir[20] = fir_data[20]*FIR_C20;   fir[21] = fir_data[21]*FIR_C21;   fir[22] = fir_data[22]*FIR_C22;   fir[23] = fir_data[23]*FIR_C23;
    fir[24] = fir_data[24]*FIR_C24;   fir[25] = fir_data[25]*FIR_C25;   fir[26] = fir_data[26]*FIR_C26;   fir[27] = fir_data[27]*FIR_C27;
    fir[28] = fir_data[28]*FIR_C28;   fir[29] = fir_data[29]*FIR_C29;   fir[30] = fir_data[30]*FIR_C30;   fir[31] = fir_data[31]*FIR_C31;
    fir_out1 =   (fir[0] + fir[1]) +   (fir[2] + fir[3]) +   (fir[4] + fir[5]) +   (fir[6] + fir[7]);
    fir_out2 =   (fir[8] + fir[9]) + (fir[10] + fir[11]) + (fir[12] + fir[13]) + (fir[14] + fir[15]);
    fir_out3 = (fir[16] + fir[17]) + (fir[18] + fir[19]) + (fir[20] + fir[21]) + (fir[22] + fir[23]);
    fir_out4 = (fir[24] + fir[25]) + (fir[26] + fir[27]) + (fir[28] + fir[29]) + (fir[30] + fir[31]);
    fir_out  = (fir_out1 + fir_out2) + (fir_out3 + fir_out4);
end

always @( posedge clk or posedge rst ) begin
    if( rst ) begin
        count <= 0;
        fir_valid <= 0;
    end
    else begin
        fir_data[0] <= data;
        for(i=0;i<31;i=i+1)
            fir_data[i+1] <= fir_data[i];

        case ( current_state )
            0: ;
            1: begin
                if( count == 30 )
                    count <= 0;
                else
                    count <= count +1;
            end
            2: begin
                fir_valid <= 1;  
                if(fir_out[35]==1'b1) begin //  !!  如果是負數就在最後一位+1  !!
                    fir_d <= {fir_out[35],fir_out[30:16]}+16'h0001;
                    reg_data[count] <= {fir_out[35],fir_out[30:16]}+16'h0001;
                end
                else begin
                    fir_d <= {fir_out[35],fir_out[30:16]};
                    reg_data[count] <= {fir_out[35],fir_out[30:16]};
                end

                if( count == 15 )
                    count <= 0;
                else
                    count <= count +1;
            end
            default: begin
                fir_valid <= 1;  
                if(fir_out[35]==1'b1) begin
                    fir_d <= {fir_out[35],fir_out[30:16]}+16'h0001;
                    reg_data[count] <= {fir_out[35],fir_out[30:16]}+16'h0001;
                end
                else begin
                    fir_d <= {fir_out[35],fir_out[30:16]};
                    reg_data[count] <= {fir_out[35],fir_out[30:16]};
                end

                if( count == 15 )
                    count <= 0;
                else
                    count <= count +1;
            end
        endcase        
    end
end

always @( * ) begin
    case ( current_state )
        0: begin // wait
            if ( data_valid == 1 )
                next_state = 1;
            else
                next_state = 0; 
        end
        1: begin // initail
            if( count == 30 )
                next_state = 2;
            else
                next_state = 1;
        end
        2: begin // FIR
            if( count == 15 )
                next_state = 3;
            else
                next_state = 2;
        end
        3: begin // FIR + FFT
            if( count == 15 )
                next_state = 4;
            else
                next_state = 3;
        end
        4: begin // FIR + FFT + Analysis
            next_state = 4;
        end
        default: ;
    endcase
end

always @( posedge clk or posedge rst ) begin
    if( rst )
        current_state <= 0;        
    else 
        current_state <= next_state;
end

endmodule

