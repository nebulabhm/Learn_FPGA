module led_ctrl(Clk, Rst_n, key_flag0, key_flag1, key_state0, key_state1, led);
	input Clk;
	input Rst_n;
	input key_flag0, key_flag1;
	input key_state0, key_state1;
	output [3:0] led;
	
	reg [3:0] led_r;
	always@(posedge Clk or negedge Rst_n)
		if (!Rst_n)
			led_r <= 4'b0000;
		else if (key_flag0 && !key_state0)
			led_r <= led_r + 1'b1;
		else if (key_flag1 && !key_state1)
			led_r <= led_r - 1'b1;
		else
			led_r <= led_r;
	assign led = ~led_r;
			
endmodule
