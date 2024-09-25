`timescale 1ns/1ns
`define clock_period 20

module key_filter_tb;
	
	reg clk;
	reg rst_n;
	
	wire key_in;
	wire key_flag;
	wire key_state;	
	
	
	key_stable key_stable0(
		.Clk(clk),
		.Rst_n(rst_n),
		.key_in(key_in),
		.key_state(key_state),
		.key_flag(key_flag)
		);
	
			
	initial clk = 1;
	always #(`clock_period/2) clk = ~clk;
	
	initial begin
		rst_n = 1'b0;
		#(`clock_period * 10);
		rst_n = 1'b1;
		#(`clock_period * 20);
		
		//key_module key_module1(.key_in(key_in));
	end
	key_module key_module1(.key_in(key_in));
	
endmodule
