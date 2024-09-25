`timescale 1ns/1ns
`define clock_period 20

module hello_tb;
	
	reg clk;
	reg rst_n;

	reg [7:0] address;
	wire q;	
	
	rom rom0(
		.address(address),
		.clock(clock),
		.q(q)
	);
		
	initial clk = 1;
	always #(`clock_period/2) clk = ~clk;
	
	initial begin

	end
endmodule
