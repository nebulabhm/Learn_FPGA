module dled_hex8(Clk, Rst_n, Disp_data, En, seg, sel);
	
	input Clk;
	input Rst_n;
	input [31:0] Disp_data;
	input En;
	
	output seg;
	output sel;
	
	wire [7:0] sel;
	wire [6:0] seg;
	
	wire Clk_1k0;
	crystal_1KHz crystal_1KHz0(
		.Clk(Clk), 
		.Rst_n(Rst_n), 
		.En(En), 
		.Clk_1k(Clk_1k0)
	);
	
	
	wire [7:0] sel_r;
	loop_shifter_8b loop_shifter_8b0(
		.Rst_n(Rst_n), 
		.Clk_1k(Clk_1k0), 
		.sel_r(sel_r)
	);
	
	wire [3:0] data_tmp;
	dled_decoder dled_decoder0(
		.sel_r(sel_r), 
		.disp_data(Disp_data), 
		.data_tmp(data_tmp)
		);
	
	dled_disp_data_decoder dled_disp_data_decoder0(
		.data_tmp(data_tmp), 
		.seg(seg)
	);
	
	dled_module_enable dled_module_enable0(
		.sel_r(sel_r), 
		.En(En), 
		.sel(sel)
	);

endmodule
