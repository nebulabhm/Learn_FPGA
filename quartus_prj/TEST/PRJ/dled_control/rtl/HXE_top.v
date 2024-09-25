module HXE_top(Clk, Rst_n, SH_CP, ST_CP, DS);

	input Clk;
	input Rst_n;
	
	output SH_CP;
	output ST_CP;
	output DS;
	
	wire [31:0] disp_data;
	wire [7:0] sel;
	wire [6:0] seg;
	
	hex_data hex_data(
		.probe(),
		.source(disp_data)
	);
	
	dled_hex8 dled_hex8(
		.Clk(Clk),
		.Rst_n(Rst_n),
		.En(1'b1),
		.Disp_data(disp_data),
		.sel(sel),
		.seg(seg)
		
	);
	
	HC595_Driver HC595_Driver(
		.Clk(Clk),
		.Rst_n(Rst_n),
		.r_data({1'b1, seg, sel}),
		.En(1'b1),
		.SH_CP(SH_CP),
		.ST_CP(ST_CP),
		.DS(DS)
	);
	

endmodule
