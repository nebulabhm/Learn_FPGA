module crystal_1KHz(Clk, Rst_n, En, Clk_1k);

	input Clk;
	input Rst_n;
	input En;
	output Clk_1k;
	
	reg Clk_1k;
	reg [14:0] divider_cnt;
	always@(posedge Clk or negedge Rst_n)
		if (!Rst_n)
			divider_cnt <= 15'b0;
		else if (!En)
			divider_cnt <= 15'b0;
		else if (divider_cnt == 15'd24999)
			divider_cnt <= 15'b0;
		else 
			divider_cnt <= divider_cnt + 1'b1;
		
	always@(posedge Clk or negedge Rst_n)
		if (!Rst_n)
			Clk_1k <= 1'b0;
		else if (divider_cnt == 15'd24999)
			Clk_1k <= ~Clk_1k;
		else 
			Clk_1k <= Clk_1k;
	
endmodule
