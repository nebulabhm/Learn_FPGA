`timescale 1ns/1ns
`define clock_period 20

module HC595_Driver_tb;
	
	reg clk;
	reg rst_n;
	reg [31:0] r_data;
	reg en;
	
	wire DS;
	wire SH_CP;
	wire ST_CP;

	
	HC595_Driver HC595_Driver0(
		.Clk(clk), 
		.Rst_n(rst_n), 
		.En(en), 
		.r_data(r_data), 
		.DS(DS), 
		.SH_CP(SH_CP), 
		.ST_CP(ST_CP)
	);
		
	initial clk = 1;
	always #(`clock_period/2) clk = ~clk;
	
	initial begin
		rst_n = 1'b0;
		en = 1;
		r_data = 32'h12345678;
		#(`clock_period * 20);
		rst_n = 1'b1;
		#(`clock_period * 20);
		#20000000;
		r_data = 32'h87654321;
		#20000000;
		r_data = 32'h89dabcdef;
		#20000000;
		$stop;
		
	end
	
endmodule
