`timescale 1ns/1ns
`define clock_period 26

module counter_tb;
	reg clk;
	reg rst_n;
	
	wire sync1, sync2, osc1, osc2;
	
	
	counter counter0(
		.Clk50M(clk),
		.Rst_n(rst_n),
		.sync1(sync1),
		.sync2(sync2),
		.osc1(osc1),
		.osc2(osc2)
	);
	
	initial clk = 1;
	always #(`clock_period/2) clk = ~clk;
	
	initial begin
		rst_n = 1'b0;
		#(`clock_period * 200);
		rst_n = 1'b1;
		#2000000;
		$stop;
		
	end
endmodule
