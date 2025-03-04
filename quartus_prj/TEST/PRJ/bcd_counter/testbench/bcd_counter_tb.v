`timescale 1ns/1ns
`define clock_period 20

module bcd_counter_tb;
	reg cin;
	reg clk;
	reg rst_n;
	
	wire cout;
	wire [3:0] q;
	
	bcd_counter bcd_counter0(
		.Cin(cin),
		.clk(clk),
		.Rst_n(rst_n),
		.Cout(cout),
		.q(q)
		);
		
	initial clk = 1;
	always #(`clock_period/2) clk = ~clk;
	
	initial begin
		rst_n = 1'b0;
		cin = 1'b0;
		#(`clock_period * 200);
		rst_n = 1'b1;
		#(`clock_period * 20);
		repeat(30) begin
			cin = 1'b1;
			#(`clock_period);
			cin = 1'b0;
			#(`clock_period * 5);
		end
		#(`clock_period * 20);
		$stop;
	end
endmodule

		