
`timescale 1ns/10ps

module  CONV(
	input							clk,
	input							reset,
	output	reg						busy,	
	input							ready,	
			
	output	reg			[11:0]		iaddr,
	input				[19:0]		idata,	
	
	output	reg	 					cwr,
	output	reg 		[11:0]		caddr_wr,
	output	reg signed	[19:0] 		cdata_wr,
	
	output	reg 					crd,
	output	reg			[11:0] 		caddr_rd,
	input	 			[19:0]		cdata_rd,
	
	output	reg 		[2:0]		csel
	);

	reg 		[3:0]		current_state, next_state;
	reg 		[3:0]		counter;
	reg			[11:0]		counter_addr;
	reg signed	[19:0]		buffer [8:0];

	wire 		[11:0]		addr [8:0], addr_p [3:0];
	wire signed	[39:0]		conv_result	[9:0];

	parameter	[2:0]	START_C	= 3'd0,
						LOAD_C	= 3'd1,
						STORE_C	= 3'd2,
						START_P	= 3'd3,
						LOAD_P	= 3'd4,
						STORE_P	= 3'd5,
						END		= 3'd6
	;

	parameter	signed 	[19:0]	kernel_0 = 20'h0A89E;
	parameter	signed 	[19:0]	kernel_1 = 20'h092D5;
	parameter	signed 	[19:0]	kernel_2 = 20'h06D43;
	parameter	signed 	[19:0]	kernel_3 = 20'h01004;
	parameter	signed 	[19:0]	kernel_4 = 20'hF8F71;
	parameter	signed 	[19:0]	kernel_5 = 20'hF6E54;
	parameter	signed 	[19:0]	kernel_6 = 20'hFA6D7;
	parameter	signed 	[19:0]	kernel_7 = 20'hFC834;
	parameter	signed 	[19:0]	kernel_8 = 20'hFAC19;
	parameter	signed 	[39:0] 	bias	 = 40'b000010011000100000000000000000000;

	assign addr[0] = counter_addr - 11'd65;
	assign addr[1] = counter_addr - 11'd64;
	assign addr[2] = counter_addr - 11'd63;
	assign addr[3] = counter_addr - 11'd1;
	assign addr[4] = counter_addr;
	assign addr[5] = counter_addr + 11'd1;
	assign addr[6] = counter_addr + 11'd63;
	assign addr[7] = counter_addr + 11'd64;
	assign addr[8] = counter_addr + 11'd65;

	assign addr_p[0] = counter_addr;
	assign addr_p[1] = counter_addr + 11'd1;
	assign addr_p[2] = counter_addr + 11'd64;
	assign addr_p[3] = counter_addr + 11'd65;


	assign conv_result[0] = buffer[0] * kernel_0 ;
	assign conv_result[1] = buffer[1] * kernel_1 ;
	assign conv_result[2] = buffer[2] * kernel_2 ;
	assign conv_result[3] = buffer[3] * kernel_3 ;
	assign conv_result[4] = buffer[4] * kernel_4 ;
	assign conv_result[5] = buffer[5] * kernel_5 ;
	assign conv_result[6] = buffer[6] * kernel_6 ;
	assign conv_result[7] = buffer[7] * kernel_7 ;
	assign conv_result[8] = buffer[8] * kernel_8 ;

	assign conv_result[9] = ( conv_result[0] + conv_result[1] + conv_result[2] +
							  conv_result[3] + conv_result[4] + conv_result[5] +
							  conv_result[6] + conv_result[7] + conv_result[8] + bias );


always @( posedge clk or posedge reset ) begin
	if( reset ) begin
		current_state <= START_C;
		counter <= 4'd0;
		counter_addr <= 12'd0;
		iaddr <= 0;
		caddr_wr <= 12'd0;
		cdata_wr <= 20'd0;
		cwr <= 1'b0;
		crd <= 1'b0;
		csel <= 3'b000;
		busy <= 1'b0;

		buffer[0] <= 20'd0;
		buffer[1] <= 20'd0;
		buffer[2] <= 20'd0;
		buffer[3] <= 20'd0;
		buffer[4] <= 20'd0;
		buffer[5] <= 20'd0;
		buffer[6] <= 20'd0;
		buffer[7] <= 20'd0;
		buffer[8] <= 20'd0;
	end
	else begin
		current_state <= next_state;
		case (current_state)
			START_C: begin
				busy <= (ready) ? 1'b1 : busy;
				iaddr <= addr[counter];
				caddr_wr <= (ready) ? caddr_wr : caddr_wr + 12'd1;
				counter <= counter + 4'd1;
				cwr <= 1'b0;
				csel <= 3'b001;

				buffer[0] <= 20'd0;
				buffer[1] <= 20'd0;
				buffer[2] <= 20'd0;
				buffer[3] <= 20'd0;
				buffer[4] <= 20'd0;
				buffer[5] <= 20'd0;
				buffer[6] <= 20'd0;
				buffer[7] <= 20'd0;
				buffer[8] <= 20'd0;	
			end 
			LOAD_C: begin
				iaddr <= (counter < 4'd9) ? addr[counter] : addr[8];
				counter <= (counter == 4'd9) ? 4'd0 : counter + 4'd1;

				if(	((counter == 4'd1 || counter == 4'd2 || counter == 4'd3) && (counter_addr[11:6] == 6'b000000)) || 
					((counter == 4'd7 || counter == 4'd8 || counter == 4'd9) && (counter_addr[11:6] == 6'b111111)) || 
					((counter == 4'd1 || counter == 4'd4 || counter == 4'd7) && (counter_addr[5:0] == 6'b000000)) || 
					((counter == 4'd3 || counter == 4'd6 || counter == 4'd9) && (counter_addr[5:0] == 6'b111111))) begin
					buffer[counter-1] <= 20'd0;
				end
				else begin
					buffer[counter-1] <= idata;
				end
			end
			STORE_C: begin
				counter_addr <= counter_addr + 12'd1;
				cwr <= 1'b1;
				if( conv_result[9][39] == 0 ) begin
					cdata_wr <= (conv_result[9][15] == 1'b0) ? conv_result[9][35:16] : (conv_result[9][35:16] +1'b1);
				end
				else begin
					cdata_wr <= 20'd0;
				end
			end
			START_P: begin
				caddr_rd <= addr_p[counter];
				caddr_wr <= caddr_wr + 12'd1;
				counter <= counter + 4'd1;
				crd <= 1'b1;
				cwr <= 1'b0;
				csel <= 3'b001;

				buffer[0] <= 20'd0;
			end
			LOAD_P: begin
				caddr_rd <= (counter < 4'd4) ? addr_p[counter] : addr_p[3];
				counter <= (counter == 4'd4) ? 4'd0 : counter + 4'd1;
				buffer[0] <= (cdata_rd > buffer[0]) ? cdata_rd : buffer[0];
			end
			STORE_P: begin
				counter_addr <= (counter_addr[5:0] == 6'b111110) ? counter_addr + 12'd66  : counter_addr + 12'd2;
				crd <= 1'b0;
				cwr <= 1'b1;
				csel <= 3'b011;
				cdata_wr <= buffer[0];
			end
			END: begin
				busy <= 1'b0;
			end
			default: busy <= 1'b0;
		endcase
	end
end

always@( * ) begin
	case( current_state )
		START_C: begin
			next_state = LOAD_C;
		end
		LOAD_C: begin
			next_state = (counter == 4'd9) ? STORE_C : LOAD_C;
		end
		STORE_C: begin
			next_state = (caddr_wr == 12'd4095) ? START_P : START_C;
		end
		START_P: begin
			next_state = LOAD_P;
		end
		LOAD_P: begin
			next_state = (counter == 4'd4) ? STORE_P : LOAD_P;
		end
		STORE_P: begin
			next_state = (caddr_wr == 12'd1023) ? END : START_P;
		end
		END:begin
			next_state = START_C;
		end
		default: begin
			next_state = START_C;
		end
	endcase
end


endmodule




