`timescale 1ns/1ns

module key_module(key);
	
	output reg key;

	reg [15:0] myrand;
	
	initial begin
		key_in = 1'b1;
		// stimulate 20ms jitter of key push-down
		press_key; 
		# 10000;
		press_key; 
		# 10000;
		press_key; 
		# 10000;
		
		$stop;	
	end
	
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
	
endmodule
