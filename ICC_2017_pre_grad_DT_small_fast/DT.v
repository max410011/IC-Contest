module DT(
	input 					clk, 
	input					reset,
	output	reg				done,
	output	reg				sti_rd,
	output	reg 	[9:0]	sti_addr,
	input			[15:0]	sti_di,
	output	reg				res_wr,
	output	reg				res_rd,
	output	reg 	[13:0]	res_addr,
	output	reg 	[7:0]	res_do,
	input			[7:0]	res_di
	);

reg [1:0] current_state, next_state;
reg [2:0] state;
reg [13:0] addr;
reg [5:0] data_1,data_2;
reg [1:0] load_num;

parameter START    = 2'd0,
		  FORWARD  = 2'd1,
		  BACKWARD = 2'd2,
		  END	   = 2'd3;

always @( posedge clk or negedge reset ) begin
	if( !reset ) begin
		current_state <= START;
	end
	else begin
		current_state <= next_state;
		case ( current_state )
			START: begin
				done <= 1'd0;
				sti_rd <= 1'd1;
				res_rd <= 1'd1;
				res_wr <= 1'd0;
				sti_addr <= 10'd8;
				addr <= 14'd129;
				res_addr <= 14'd129;
				load_num <= 2'd3; 
				res_do <= 8'd0;
				data_1 <= 8'd0;
				data_2 <= 8'd0;
				state <= 3'd0;
			end 
			FORWARD: begin
				case ( state )
					0: begin
						if( addr[3:0] == 4'd15)
							sti_addr <= sti_addr + 10'd1; 

						if( sti_di[4'd15 - addr[3:0]] == 1'd0 ) begin	// 非物件，跳下一個
							addr <= addr + 14'd1;
							res_do[5:0] <= 8'd0;
							res_addr <= addr + 14'd1;
							load_num <= ( load_num < 2'd3) ? load_num + 2'd1 : load_num;
							data_1 <= data_2;
						end
						else begin		// 物件，進入forward pass
							case ( load_num )
								3: begin
									res_addr <= addr - 14'd129;
									state <= 3'd1;
								end 
								2: begin
									res_addr <= addr - 14'd128;
									res_do[5:0] <= ( res_do[5:0] <= data_2 ) ? res_do[5:0] : data_2;
									state <= 3'd2;
								end 
								1: begin
									res_addr <= addr - 14'd127;
									if( data_1 <= data_2 && data_1 <= res_do[5:0] )
										res_do[5:0] <= data_1;
									else if( data_2 <= res_do[5:0] )
										res_do[5:0] <= data_2;
									state <= 3'd3;
								end 
							endcase
						end
					end 
					1: begin
						res_addr <= addr - 14'd128;
						res_do[5:0] <= ( res_do[5:0] <= res_di[5:0] ) ? res_do[5:0] : res_di[5:0];
						state <= 3'd2;
					end
					2: begin
						res_addr <= addr - 14'd127;
						data_2 <= res_di[5:0];
						res_do[5:0] <= ( res_do[5:0] <= res_di[5:0] ) ? res_do[5:0] : res_di[5:0];
						state <= 3'd3;
					end
					3: begin
						res_wr <= 1'd1;
						res_addr <= addr;
						data_1 <= data_2;
						data_2 <= res_di[5:0];
						res_do[5:0] <= ( res_do[5:0] <= res_di[5:0] ) ? res_do[5:0] + 8'd1 : res_di[5:0] + 8'd1;
						state <= 3'd4;
					end
					4: begin
						res_wr <= 1'd0;
						addr <= addr + 14'd1;
						res_addr <= addr + 14'd1;
						res_do[5:0] <= res_do[5:0] + 8'd1;
						load_num <= 2'd1;
						state <= 3'd0;
					end
				endcase
			end
			BACKWARD: begin
				case ( state )
					0: begin
						if( res_di[5:0] == 8'd0 ) begin	// 非物件，跳下一個
							addr <= addr - 14'd1;
							res_addr <= addr - 14'd1;
							res_do[5:0] <= 8'd0;
							load_num <= ( load_num < 2'd3) ? load_num + 2'd1 : load_num;
							data_1 <= data_2;
						end
						else begin			// 物件，進入backward pass
						case ( load_num )
								3: begin
									res_addr <= addr + 14'd129;
									res_do[5:0] <= ( res_di[5:0] - 8'd1 <= res_do[5:0]) ? res_di[5:0] - 8'd1 : res_do[5:0];
									state <= 3'd1;
								end 
								2: begin
									res_addr <= addr + 14'd128;
									if( res_di[5:0] - 8'd1 <= res_do[5:0] && res_di[5:0] - 8'd1 <= data_2 )
										res_do[5:0] <= res_di[5:0] - 8'd1;
									else if( data_2 <= res_do[5:0] )
										res_do[5:0] <= data_2;
									state <= 3'd2;
								end 
								1: begin
									res_addr <= addr + 14'd127;
									if( res_di[5:0] - 8'd1 <= res_do[5:0] && res_di[5:0] - 8'd1 <= data_2 && res_di[5:0] - 8'd1 <= data_1)
										res_do[5:0] <= res_di[5:0] - 8'd1;
									else if( data_2 <= res_do[5:0] && data_2 <= data_1)
										res_do[5:0] <= data_2;
									else if( data_1 <= res_do[5:0] )
										res_do[5:0] <= data_1;
									state <= 3'd3;
								end 
							endcase
						end
					end 
					1: begin
						res_addr <= addr + 14'd128;
						res_do[5:0] <= ( res_do[5:0] <= res_di[5:0] ) ? res_do[5:0] : res_di[5:0];
						state <= 3'd2;
					end
					2: begin
						res_addr <= addr + 14'd127;
						data_2 <= res_di[5:0];
						res_do[5:0] <= ( res_do[5:0] <= res_di[5:0] ) ? res_do[5:0] : res_di[5:0];
						state <= 3'd3;
					end
					3: begin
						res_wr <= 1'd1;
						res_addr <= addr;
						data_1 <= data_2;
						data_2 <= res_di[5:0];
						res_do[5:0] <= ( res_do[5:0] <= res_di[5:0] ) ? res_do[5:0] + 8'd1 : res_di[5:0] + 8'd1;
						state <= 3'd4;
					end
					4: begin
						res_wr <= 1'd0;
						addr <= addr - 14'd1;
						res_addr <= addr - 14'd1;
						load_num <= 2'd1;
						state <= 3'd0;
					end
				endcase
			end
			END: begin
				done <= 1'd1;
			end
		endcase
	end
end

always @( * ) begin
	case ( current_state )
		START: begin
			next_state = FORWARD;
		end
		FORWARD: begin
			if( res_addr == 14'd16255 )
				next_state = BACKWARD;
			else
				next_state = FORWARD;
		end
		BACKWARD: begin
			if( res_addr == 14'd129 )
				next_state = END;
			else
				next_state = BACKWARD;
		end
		END: begin
			next_state = END;
		end 
	endcase
end


endmodule
