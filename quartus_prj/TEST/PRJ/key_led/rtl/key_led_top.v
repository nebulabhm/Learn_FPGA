module key_led_top(Clk, Rst_n, key_in0, key_in1, led);
	
	input Clk;
	input Rst_n;
	input key_in0, key_in1;
	
	output [3:0] led;
	
	wire key_flag0, key_flag1;
	wire key_state0, key_state1;
	
	key_stable key_stable0(
		.Clk(Clk),
		.Rst_n(Rst_n),
		.key_in(key_in0),
		.key_flag(key_flag0),
		.key_state(key_state0)
	);

	key_stable key_stable1(
		.Clk(Clk),
		.Rst_n(Rst_n),
		.key_in(key_in1),
		.key_flag(key_flag1),
		.key_state(key_state1)
	);	
	
	led_ctrl led_ctrl0(
		.Clk(Clk),
		.Rst_n(Rst_n),
		.key_flag0(key_flag0),
		.key_state0(key_state0),
		.key_flag1(key_flag1),
		.key_state1(key_state1),
		.led(led)
	);
	
endmodule
