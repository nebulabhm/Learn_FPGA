`timescale 1ns/1ns
`define clock_period 20

module fifo_ip_tb;
	
	reg clk;
	reg [15:0]  data;
	reg rdreq;
	reg sclr;
	reg wrreq;
	
	wire almost_empty;
	wire almost_full;
	wire empty;
	wire full;
	wire [15:0]  q;
	wire [7:0]  usedw;
	
	dpram dpram0(
		.clock(clk),
		.data(data),
		.rdreq(rdreq),
		.sclr(sclr),
		.wrreq(wrreq),
		.almost_empty(almost_empty),
		.almost_full(almost_full),
		.empty(empty),
		.full(full),
		.q(q),
		.usedw(usedw)
	);
		
	initial clk = 1;
	always #(`clock_period/2) clk = ~clk;
	
	integer i,j;
	initial 
		begin
			wrreq = 0;
			data = 0;
			rdreq = 0;
			sclr = 0;
			
			#(`clock_period * 20 + 1);
			
			for (i = 0;i <= 255;i = i + 1)
				begin
					wrreq = 1;
					data = i;
					#(`clock_period);
				end
			
			wrreq = 0;
			#(`clock_period * 20);
			
			for (j = 0;j <= 255;j = j + 1)
				begin
					rdreq = j;
					#(`clock_period);
				end 
			
			rdreq = 0;
			#(`clock_period * 20);
			$stop;

		end
		
endmodule
