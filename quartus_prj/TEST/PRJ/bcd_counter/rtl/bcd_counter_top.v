module bcd_counter_top(Clk, Cin, Rst_n, Cout, q);
	
	input Clk;
	input Cin;
	input Rst_n;
	
	output Cout;
	output [11:0] q;
	
	wire Cout0, Cout1;
	wire [3:0] q0, q1, q2;
	
	assign q = {q2,q1,q0};
	
	bcd_counter bcd_counter0(
		.Clk(Clk),
		.Cin(Cin),
		.Rst_n(Rst_n),
		.Cout(Cout0),
		.q(q0)
	);

	bcd_counter bcd_counter1(
		.Clk(Clk),
		.Cin(Cout0),
		.Rst_n(Rst_n),
		.Cout(Cout1),
		.q(q1)
	);	
	
	bcd_counter bcd_counter2(
		.Clk(Clk),
		.Cin(Cout1),
		.Rst_n(Rst_n),
		.Cout(Cout),
		.q(q2)
	);
	
endmodule
