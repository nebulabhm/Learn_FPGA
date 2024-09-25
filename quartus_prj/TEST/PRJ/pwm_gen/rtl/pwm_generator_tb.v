`timescale 1ns/1ns
`define clock_period 20

module pwm_generator_tb;

	reg Clk;
	reg Rst_n;
	reg cnt_en;
	reg [31:0] counter_arr;
	reg [31:0] counter_ccr;
	
	wire o_pwm;
	
	pwm_generator pwm_generator(
		.Clk(Clk),
		.Rst_n(Rst_n),
		.cnt_en(cnt_en),
		.counter_arr(counter_arr),
		.counter_ccr(counter_ccr),
		
		.o_pwm(o_pwm)
	);
	
	initial Clk = 1;
	always#(`clock_period/2) Clk = ~Clk;
	
	initial begin
		Rst_n = 0;
		cnt_en = 0;
		counter_arr = 0;
		counter_ccr = 0;
		#(`clock_period * 20 + 1);
		Rst_n = 1;
		#(`clock_period * 10 + 1);
		counter_arr = 999;	//设置输出信号频率为50KHz
		counter_ccr = 400;	// 占空比为40%
		#(`clock_period * 10);
		cnt_en = 1;
		#100050;
		counter_ccr = 700;
		#100050;
		cnt_en = 0;
		counter_arr = 499;	// 设置输出信号频率为100KHz
		counter_ccr = 250;
		#(`clock_period * 10);
		cnt_en = 1;
		#50050;
		counter_ccr = 100;
		#50050;
		$stop;
	end
	
	
endmodule
