`timescale 1ns/1ps
`define clock_period 20

module counter_pll_tb;
	
	//source define
	reg clk;
	reg Rst_n;
	
	//probe define
	wire [3:0] led;
	
	//instant user module
	counter_pll_top counter_pll_top(
		.Clk(clk), 
		.Rst_n(Rst_n),
		.led(led)
	);
	
	defparam counter_pll_top.counter0.CNT_MAX = 25'd24;
	defparam counter_pll_top.counter1.CNT_MAX = 25'd24;
	defparam counter_pll_top.counter2.CNT_MAX = 25'd24;
	defparam counter_pll_top.counter3.CNT_MAX = 25'd24;
		
	// generate clock	
	initial clk = 1;
	always #(`clock_period/2) clk = ~clk;
	
	initial 
		begin
			Rst_n = 1'b0;
			#(`clock_period * 20 + 1);
			
			Rst_n = 1'b1;
			#(`clock_period * 2000);
			$stop;
		end
endmodule
