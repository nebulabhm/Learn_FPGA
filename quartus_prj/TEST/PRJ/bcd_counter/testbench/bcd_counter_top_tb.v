`timescale 1ns/1ns
`define clock_period 20

module bcd_counter_top_tb;
	reg cin;
	reg clk;
	reg rst_n;
	
	wire cout;
	wire [11:0] q;
	
	bcd_counter_top bcd_counter_top0(
		.Cin(cin),
		.Clk(clk),
		.Rst_n(rst_n),
		.Cout(cout),
		.q(q)
		);
		
	initial clk = 1;
	//initial cin = 0;
	always #(`clock_period/2) clk = ~clk;
	
	initial begin
		rst_n = 1'b0;
		cin = 1'b0;
		#(`clock_period * 200);
		rst_n = 1'b1;
		#(`clock_period * 20);
		cin = 1'b1;
		#(`clock_period * 5000);
		$stop;
	end
endmodule