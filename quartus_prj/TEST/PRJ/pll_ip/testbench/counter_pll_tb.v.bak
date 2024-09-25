`timescale 1ns/1ns
`define clock_period 20

module pll_ip_tb;
	
	reg clk;
	reg areset;
	
	wire  c0;
	wire  c1;
	wire  c2;
	wire  locked;	
	
	pll_ip pll_ip(
		.areset(areset),
		.inclk0(clk),
		.c0(c0),
		.c1(c1),
		.c2(c2),
		.locked(locked)
	);
		
	initial clk = 1;
	always #(`clock_period/2) clk = ~clk;
	
	initial 
		begin
			areset = 1'b1;
			#(`clock_period * 100 + 1);
			
			areset = 1'b0;
			#(`clock_period * 200 + 1);
			$stop;
		end
endmodule
