module counter_pll_top(
	Clk, 
	Rst_n,
	led
	);
	
	input Clk;
	input Rst_n;
	
	output [3:0] led;
	
	wire [3:0] led;
	
	wire c0, c1, c2;
	
	
	pll_ip pll_ip(
		.areset(~Rst_n),
		.inclk0(Clk),
		.c0(c0),
		.c1(c1),
		.c2(c2),
		.locked()
	);
	
	counter counter0(
		.Clk(c0), 
		.Rst_n(Rst_n), 
		.led(led[0])
	);

	counter counter1(
		.Clk(c1), 
		.Rst_n(Rst_n), 
		.led(led[1])
	);

	counter counter2(
		.Clk(c2), 
		.Rst_n(Rst_n), 
		.led(led[2])
	);
	
	counter counter3(
		.Clk(Clk), 
		.Rst_n(Rst_n), 
		.led(led[3])
	);
	
endmodule
