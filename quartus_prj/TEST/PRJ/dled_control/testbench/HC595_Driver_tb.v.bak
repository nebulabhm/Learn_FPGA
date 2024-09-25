`timescale 1ns/1ns
`define clock_period 20

module dled_hex8_tb;
	
	reg clk;
	reg rst_n;
	reg [31:0] disp_data;
	reg en;
	
	wire [3:0] seg;
	wire [7:0] sel;

	
	dled_hex8 dled_hex80(
		.Clk(clk), 
		.Rst_n(rst_n), 
		.Disp_data(disp_data), 
		.En(en), 
		.seg(seg), 
		.sel(sel)
	);
		
	initial clk = 1;
	always #(`clock_period/2) clk = ~clk;
	
	initial begin
		rst_n = 1'b0;
		en = 1;
		disp_data = 32'h12345678;
		#(`clock_period * 20);
		rst_n = 1'b1;
		#(`clock_period * 20);
		#20000000;
		disp_data = 32'h87654321;
		#20000000;
		disp_data = 32'h89dabcdef;
		#20000000;
		$stop;
		
	end
	
endmodule
