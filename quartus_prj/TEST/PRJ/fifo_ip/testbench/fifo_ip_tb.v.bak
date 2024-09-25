`timescale 1ns/1ns
`define clock_period 20

module dpram_tb;
	
	reg clk;
	reg [7:0]  data;
	reg [7:0]  rdaddress;
	reg [7:0]  wraddress;
	reg wren;
	
	wire	[7:0]  q;
	
	dpram dpram0(
		.clock(clk),
		.data(data),
		.rdaddress(rdaddress),
		.wraddress(wraddress),
		.wren(wren),
		.q(q)
	);
		
	initial clk = 1;
	always #(`clock_period/2) clk = ~clk;
	
	reg [7:0] i,j;
	initial 
		begin
			data = 0;
			rdaddress = 30;
			wraddress = 0;
			wren = 0;
			#(`clock_period * 20 + 1);
			
			for (i = 0;i <= 15;i = i + 1)
				begin
					wren = 1;
					data = 255 - i;
					wraddress = i;
					//rdaddress = i;
					#(`clock_period);
				end
			
			wren = 0;
			#(`clock_period * 20);
			
			for (j = 0;j <= 15;j = j + 1)
				begin
					rdaddress = j;
					#(`clock_period);
				end 
			
			#(`clock_period * 20);
			$stop;

		end
		
endmodule
