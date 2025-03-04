`timescale 1ns/1ns
`define clock_period 20

module rom_tb;
	
	reg clk;
	reg rst_n;

	reg [7:0] address;
	wire [7:0] q;	
	
	rom rom0(
		.address(address),
		.clock(clk),
		.q(q)
	);
		
	initial clk = 1;
	always #(`clock_period/2) clk = ~clk;
	
	integer i;
	initial 
		begin
			address = 0;
			#21;
			for (i = 0;i <= 2550;i = i + 1)
			begin
				#`clock_period;
				address = address + 1;
			end
			#(`clock_period);
			$stop;
		end
endmodule
