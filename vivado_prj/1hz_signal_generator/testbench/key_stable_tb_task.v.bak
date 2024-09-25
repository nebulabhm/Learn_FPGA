`timescale 1ns/1ns
`define clock_period 20

module key_stable_tb;
	
	reg clk;
	reg rst_n;
	reg key_in;
	
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
		rst_n = 0;
		#(`clock_period * 20);
		rst_n = 1;
		#(`clock_period * 20 + 1);
		
		// stimulate 20ms jitter of key push-down
		key_in = 0; # 1000;
		key_in = 1; # 2000;
		key_in = 0; # 1400;
		key_in = 1; # 2600;
		key_in = 0; # 1300;
		key_in = 1; # 200;
		
		// stimulate stable push-down
		key_in = 0; #20_000_100;
		#50_000_000;
		
		// stimulate release jitter within 20ms
		key_in = 1; # 2000;
		key_in = 0; # 1000;
		key_in = 1; # 2000;
		key_in = 0; # 2000;
		key_in = 0; # 1400;
		key_in = 1; # 2600;
		key_in = 0; # 1300;
		key_in = 1; # 200;
		
		key_in = 1; # 50_000_100;
		#30000;
		
	end
endmodule
