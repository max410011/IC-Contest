`timescale 1ns/10ps
`define CYCLE    100           	        // Modify your clock period here


`define SDFFILE  "./lcd_ctrl_syn.sdf"	// Modify your sdf file name

`define tb1
`ifdef tb1
  `define EXPECT "./tb1_goal.dat"
  `define CMD "./cmd1.dat"
`endif

`ifdef tb2
  `define EXPECT "./tb2_goal.dat"
  `define CMD "./cmd2.dat"
`endif

`include "IRB.v"
`include "IROM.v"

module test;
parameter IMAGE_N_PAT = 64;
parameter CMD_N_PAT = 45;
parameter t_reset = `CYCLE*2;


reg clk;
reg reset;
reg [6:0] err_IRB;
reg [2:0] cmd;
reg cmd_valid;
reg [7:0]  out_mem[0:63];


wire IROM_EN;
wire [5:0] IROM_A;
wire IRB_RW;
wire [7:0] IRB_D;
wire [5:0] IRB_A;
wire busy;
wire done;
wire [7:0]  IROM_Q;


integer i, j, k, l, err;

reg over;
reg   [2:0]   cmd_mem   [0:CMD_N_PAT-1];



	LCD_CTRL top(.clk(clk), .reset(reset), .IROM_Q(IROM_Q), 
		     .cmd(cmd), .cmd_valid(cmd_valid), .IROM_EN(IROM_EN),
                     .IROM_A(IROM_A), .IRB_RW(IRB_RW), .IRB_D(IRB_D), .IRB_A(IRB_A),
		     .busy(busy), .done(done));





	IROM  IROM_1 (.Q(IROM_Q), .CLK(clk), .CEN(IROM_EN), .A(IROM_A));

	IRB  IRB_1 (.Q(), .CLK(clk), .CEN(1'b0), .WEN(IRB_RW), .A(IRB_A), .D(IRB_D));


`ifdef SDF
  initial $sdf_annotate(`SDFFILE, top);
`endif

initial	$readmemh (`CMD,    cmd_mem);
initial	$readmemh (`EXPECT, out_mem);

initial begin

$fsdbDumpfile("LCD_CTRL.fsdb");
$fsdbDumpvars;

end





initial begin
   clk         = 1'b0;
   reset       = 1'b0;
   over	       = 1'b0;
   l	       = 0;
   err         = 0;   
end

always begin #(`CYCLE/2) clk = ~clk; end

initial begin
   @(negedge clk)  reset = 1'b1;
   #t_reset        reset = 1'b0;
                                  
end  

            
 always @(negedge clk)
begin

	begin
	if (l < CMD_N_PAT)
	begin
		if(!busy) 
		begin
        	cmd = cmd_mem[l];
        	cmd_valid = 1'b1;
		l=l+1;
		end  
		else
		cmd_valid = 1'b0;
	end
	else
	l=l;
	end
end


initial @(posedge done) 
begin
   for(k=0;k<64;k=k+1)begin
         if( IRB_1.mem[k] !== out_mem[k]) 
		begin
         	$display("ERROR at %d:output %h !=expect %h ",k, IRB_1.mem[k], out_mem[k]);
         	err = err+1 ;
		end
         else if ( out_mem[k] === 8'dx)
                begin
                $display("ERROR at %d:output %h !=expect %h ",k, IRB_1.mem[k], out_mem[k]);
		err=err+1;
                end   
 over=1'b1;
end
        begin
	if (err === 0 &&  over===1'b1  )  begin
	            $display("All data have been generated successfully!\n");
	            $display("-------------------PASS-------------------\n");
		    #10 $finish;
	         end
	         else if( over===1'b1 )
		 begin 
	            $display("There are %d errors!\n", err);
	            $display("---------------------------------------------\n");
		    #10 $finish;
         	 end
	
	end
end

endmodule

