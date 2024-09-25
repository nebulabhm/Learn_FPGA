module dled_module_enable(sel_r, En, sel);

	input [7:0] sel_r;
	input En;
	output wire [7:0] sel;
	
	assign sel = (En)? sel_r : 8'b0000_0000;

endmodule
