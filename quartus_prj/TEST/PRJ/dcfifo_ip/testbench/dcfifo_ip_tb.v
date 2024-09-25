`timescale 1ns/1ns
`define wrclk_period 20
`define rdclk_period 10

module dcfifo_ip_tb;
	
	reg [15:0]  data;
	reg rdclk;
	reg rdreq;
	reg wrclk;
	reg wrreq;
	
	wire rdempty;
	wire wrfull;
	wire [7:0]  q;
	
	wire [8:0]  rdusedw;
	wire [7:0]  wrusedw;
	
	dc_fifo dc_fifo(
	.data(data),
	.rdclk(rdclk),
	.rdreq(rdreq),
	.wrclk(wrclk),
	.wrreq(wrreq),
	.q(q),
	.rdempty(rdempty),
	.rdusedw(rdusedw),
	.wrfull(wrfull),
	.wrusedw(wrusedw)
	);
		
	initial wrclk = 1;
	always #(`wrclk_period/2) wrclk = ~wrclk;
	
	initial rdclk = 1;
	always #(`rdclk_period/2) rdclk = ~rdclk;
	
	integer i,j;
	initial 
		begin
			data = 0;
			rdreq = 0;
			wrreq = 0;
			
			#(`wrclk_period * 20 + 1);
			
			for (i = 0;i <= 255;i = i + 1)
				begin
					wrreq = 1;
					data = i + 1024;
					#(`wrclk_period);
				end
			
			wrreq = 0;
			#(`rdclk_period * 20);
			
			for (j = 0;j <= 511;j = j + 1)
				begin
					rdreq = 1;
					#(`rdclk_period);
				end 
			
			rdreq = 0;
			#(`rdclk_period * 20);
			$stop;

		end
		
endmodule
