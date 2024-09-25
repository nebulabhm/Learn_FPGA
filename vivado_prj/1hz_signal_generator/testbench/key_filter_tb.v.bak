`timescale 1ns/1ns
`define clock_period 20

module key_stable_tb_task;
	
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
	
	reg [15:0] myrand;
	task press_key;
		begin
			repeat(50) begin
				#myrand key_in = ~key_in;
			end
			key_in = 0;
			#50_000_000;
			
			repeat(50) begin
				myrand = {$random} % 65536;
				#myrand key_in = ~key_in;
			end
			key_in = 1;
			#50_000_000;
		end
	endtask
	
	initial begin
		rst_n = 0;
		#(`clock_period * 20);
		key_in = 1'b1;
		rst_n = 1;
		#(`clock_period * 20 + 1);
		
		// stimulate 20ms jitter of key push-down
		press_key; # 10000;
		press_key; # 10000;
		press_key; # 10000;
		
		$stop;
		
	end
endmodule
