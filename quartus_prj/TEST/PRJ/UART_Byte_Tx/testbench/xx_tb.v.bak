`timescale 1ns/1ns
`define clock_period 20

module hello_tb;
	
	reg clk;
	reg rst_n;

	reg [7:0] ASCII;
	wire led;	
	
	hello hello0(
		.Clk(clk),
		.Rst_n(rst_n),
		.data(ASCII),
		.led(led)
		);
		
	initial clk = 1;
	always #(`clock_period/2) clk = ~clk;
	
	initial begin
		rst_n = 1'b0;
		ASCII = 0;
		#(`clock_period * 20);
		rst_n = 1'b1;
		#(`clock_period * 20 + 1);
		forever begin
			ASCII = "I";
			#(`clock_period);
			ASCII = "A";
			#(`clock_period);
			ASCII = "M";
			#(`clock_period);
			ASCII = "X";
			#(`clock_period);
			ASCII = "I";
			#(`clock_period);
			ASCII = "i";
			#(`clock_period);
			ASCII = "b";
			#(`clock_period);
			ASCII = "c";
			#(`clock_period);
			ASCII = "M";
			#(`clock_period);
			ASCII = "H";
			#(`clock_period);
			ASCII = "O";
			#(`clock_period);
			ASCII = "H";
			#(`clock_period);
			ASCII = "e";
			#(`clock_period);
			ASCII = "l";
			#(`clock_period);
			ASCII = "l";
			#(`clock_period);
			ASCII = "o";
			#(`clock_period);
			ASCII = "I";
			#(`clock_period);
			ASCII = "H";
			#(`clock_period);
			ASCII = "e";
			#(`clock_period);
			ASCII = "l";
			#(`clock_period);
			ASCII = "l";
			#(`clock_period);
			ASCII = "o";
			#(`clock_period);
			ASCII = "I";
			#(`clock_period);
			$stop;
		end
	end
endmodule
