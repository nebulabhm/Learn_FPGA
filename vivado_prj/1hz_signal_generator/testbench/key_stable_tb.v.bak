`timescale 1ns/1ns
`define clock_period 20

module hello_tb;
	
	reg clk;
	reg rst_n;

	reg [7:0] ASCII;
	wire led;	
	
	hello hello0(
		.Clk(clk),
		.Rst_n(rst_n),
		.data(ASCII),
		.led(led)
		);
		
	initial clk = 1;
	always #(`clock_period/2) clk = ~clk;
	
	initial begin

	end
endmodule
