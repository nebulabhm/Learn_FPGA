module loop_shifter_8b(Rst_n, Clk_1k, sel_r);
	
	input Rst_n;
	input Clk_1k;
	output reg [7:0] sel_r;
	
	always@(posedge Clk_1k or negedge Rst_n)
		if (!Rst_n)
			sel_r <= 8'b0000_0001;
		else if (sel_r == 8'b1000_0000)
			sel_r <= 8'b0000_0001;
		else
			sel_r <= sel_r << 1;
	
endmodule
