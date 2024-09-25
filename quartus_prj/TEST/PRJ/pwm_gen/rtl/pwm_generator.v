module pwm_generator(
	Clk,
	Rst_n,
	cnt_en,
	counter_arr,
	counter_ccr,
	
	o_pwm
	);

	input	Clk;
	input Rst_n;
	input cnt_en;
	input [31:0] counter_arr;
	input [31:0] counter_ccr;
	
	output reg o_pwm;
	
	reg [31:0] counter;
	always@(posedge Clk or negedge Rst_n)
	begin
		if (!Rst_n)
			counter <= 32'd0;
		else if (cnt_en)
			begin
				if (counter == 0)
					counter <= counter_arr;	//load default register value
				else
					counter <= counter - 1'b1;	// counter decrease one
			end
		else
			counter <= counter_arr;
	end
	
	always@(posedge Clk or negedge Rst_n)
	begin
		if (!Rst_n)
			o_pwm <= 1'b0;
		else if (counter >= counter_ccr)	// 计数值大于比较值
			o_pwm <= 1'b0;
		else
			o_pwm <= 1'b1;
	end
	
endmodule
