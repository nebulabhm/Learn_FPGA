`timescale 1ns/1ns
`define clock_period 20

module dpram_tb;
	
	reg clk;
	reg data;
	reg wren;
	reg rdaddress;
	reg wraddress;
	
	wire q;
	
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
	
	reg [3:0] i;
	initial 
		begin
			data = 0;
			rdaddress = 0;
			wraddress = 0;
			wren = 0;
			#(`clock_period * 20 + 1);
			
			for (i = 0;i <= 15;i = i + 1)
				begin
					wren = 1;
					data = 255 - i;
					wraddress = i;
					#(`clock_period);
				end
			
			wren = 0;
			#(`clock_period * 20);
			for (i = 0;i <= 15;i = i + 1)
				begin
					rdaddress = i;
					#(`clock_period);
				end 
			
			#(`clock_period * 20);
			$stop;

		end
		
endmodule
