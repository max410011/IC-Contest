module STI_DAC(

input			clk, reset,
input			load, pi_msb, pi_low, pi_end, 
input	[15:0]	pi_data,
input	[1:0]	pi_length,
input			pi_fill,

output reg so_data, so_valid,
output reg oem_finish, odd1_wr, odd2_wr, odd3_wr, odd4_wr, even1_wr, even2_wr, even3_wr, even4_wr,
output reg [4:0] oem_addr,
output reg [7:0] oem_dataout
);

//==============================================================================

reg [2:0] current_state, next_state;
reg [4:0] counter;
reg [1:0] oem;
reg odd_even;


integer i;
parameter [2:0] LOAD   = 3'd0,
				OUTPUT = 3'd1,
				ZERO   = 3'd2,
				WAIT   = 3'd3,
				END    = 3'd4;

always @(posedge clk or posedge reset) begin
	if(reset) begin
		current_state <= LOAD;
		oem_finish <= 1'd0;
		oem <= 2'd3;
		oem_addr <= 5'd31;
		odd_even <= 1'd1;
		counter <= 5'd0;
	end
	else begin
		current_state <= next_state;
		case (current_state)
			LOAD: begin
				so_valid <= 1'd0;
				counter <= 5'd0;
			end 
			OUTPUT: begin				
				so_valid <= 1'd1;
				counter <= counter + 5'd1;

				// MEM 部分

				oem_dataout[-counter[2:0]] <= so_data;

				if(counter[2:0] == 3'd1) begin // 計算oem_addr
					odd_even <= odd_even + 1'd1;
					oem_addr <= (odd_even == 1'd1) ? oem_addr + 5'd1 : oem_addr; 
					oem <= (oem_addr == 5'd31 && odd_even == 1'd1) ? oem + 2'd1 : oem;
				end
				
				if(counter[2:0] == 3'd0) begin // 每存滿一次oem_data就寫入記憶體
					odd1_wr  <= (oem == 2'd0 && (oem_addr[2] == odd_even)) ? 1'd1 : 1'd0;
					even1_wr <= (oem == 2'd0 && (oem_addr[2] != odd_even)) ? 1'd1 : 1'd0;
					odd2_wr  <= (oem == 2'd1 && (oem_addr[2] == odd_even)) ? 1'd1 : 1'd0;
					even2_wr <= (oem == 2'd1 && (oem_addr[2] != odd_even)) ? 1'd1 : 1'd0;
					odd3_wr  <= (oem == 2'd2 && (oem_addr[2] == odd_even)) ? 1'd1 : 1'd0;
					even3_wr <= (oem == 2'd2 && (oem_addr[2] != odd_even)) ? 1'd1 : 1'd0;
					odd4_wr  <= (oem == 2'd3 && (oem_addr[2] == odd_even)) ? 1'd1 : 1'd0;
					even4_wr <= (oem == 2'd3 && (oem_addr[2] != odd_even)) ? 1'd1 : 1'd0;
				end
				else begin
					odd1_wr  <= 1'd0; odd2_wr  <= 1'd0; odd3_wr  <= 1'd0; odd4_wr  <= 1'd0; 
					even1_wr <= 1'd0; even2_wr <= 1'd0; even3_wr <= 1'd0; even4_wr <= 1'd0;
				end

				// SO_DATA 部分

				if(pi_length >= 2'd2) begin  // 32bits、24bits
					if(pi_fill) begin // 放高位
						if(pi_msb) // 正序
							so_data <= (counter <= 5'd15) ? pi_data[5'd15 - counter] : 1'd0;
						else // 倒序
							so_data <= (counter <= {1'd0,pi_length[0],3'd7}) ? 1'd0 : pi_data[counter - {1'd0,pi_length[0],3'd0} - 5'd8];
					end
					else begin // 放低位
						if(pi_msb) // 正序
							so_data <= (counter <= {1'd0,pi_length[0],3'd7}) ? 1'd0 : pi_data[5'd23 + {1'd0,pi_length[0],3'd0} - counter];
						else // 倒序
							so_data <= (counter <= 5'd15) ? pi_data[counter] : 1'd0;
					end
				end
				else if(pi_length == 2'd1) begin  // 16bits
					if(pi_msb) // 正序
						so_data <= pi_data[4'd15 - counter];
					else // 倒序
						so_data <= pi_data[counter];
				end
				else begin  // 8bits
					if(pi_msb) // 正序
						so_data <= pi_data[{pi_low,3'd0} + 4'd7 - counter];
					else // 倒序
						so_data <= pi_data[{pi_low,3'd0} + counter];
				end
			end
			ZERO: begin // 沒有資料要存入的MEM補為0
				so_valid <= 1'd0;
				so_data <= 1'd0;
				oem_dataout[0] <= so_data; // 補SO_OUT最後一筆
				
				odd1_wr  <= (oem == 2'd0 && (oem_addr[2] == odd_even)) ? 1'd1 : 1'd0;
				even1_wr <= (oem == 2'd0 && (oem_addr[2] != odd_even)) ? 1'd1 : 1'd0;
				odd2_wr  <= (oem == 2'd1 && (oem_addr[2] == odd_even)) ? 1'd1 : 1'd0;
				even2_wr <= (oem == 2'd1 && (oem_addr[2] != odd_even)) ? 1'd1 : 1'd0;
				odd3_wr  <= (oem == 2'd2 && (oem_addr[2] == odd_even)) ? 1'd1 : 1'd0;
				even3_wr <= (oem == 2'd2 && (oem_addr[2] != odd_even)) ? 1'd1 : 1'd0;
				odd4_wr  <= (oem == 2'd3 && (oem_addr[2] == odd_even)) ? 1'd1 : 1'd0;
				even4_wr <= (oem == 2'd3 && (oem_addr[2] != odd_even)) ? 1'd1 : 1'd0;
			end
			WAIT: begin // 等待1個cycle，避免連續寫入同一個MEM
				oem_dataout <= 8'd0;
				odd_even <= odd_even + 1'd1;
				oem_addr <= (odd_even == 1'd1) ? oem_addr + 5'd1 : oem_addr; 
				oem <= (oem_addr == 5'd31 && odd_even == 1'd1) ? oem + 2'd1 : oem;
				odd1_wr  <= 1'd0; odd2_wr  <= 1'd0; odd3_wr  <= 1'd0; odd4_wr  <= 1'd0; 
				even1_wr <= 1'd0; even2_wr <= 1'd0; even3_wr <= 1'd0; even4_wr <= 1'd0;
			end
			END: begin
				oem_finish <= 1'd1;
			end
		endcase
	end
end


always @(*) begin
	case (current_state)
		LOAD: begin
			next_state = (load == 1'd1) ? OUTPUT : LOAD;
		end
		OUTPUT: begin
			if(counter == {pi_length,3'd7})
				next_state = (pi_end) ? ZERO : LOAD;
			else
				next_state = OUTPUT;
		end
		ZERO: begin
			next_state = WAIT;
		end
		WAIT: begin
			next_state = (oem == 2'd3 && odd_even == 1'd1 && oem_addr == 5'd31) ? END : ZERO;
		end
		default: begin
			next_state = END;
		end
	endcase
end

endmodule
