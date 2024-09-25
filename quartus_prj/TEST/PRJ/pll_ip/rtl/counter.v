module counter(Clk, Rst_n, led);
	input Clk;
	input Rst_n;
	output reg led;
	
	reg[24:0] cnt;
	
	parameter CNT_MAX = 25'd24_999_999;
	always@(posedge Clk or negedge Rst_n)
		if (Rst_n == 1'b0)
			cnt <= 25'd0;
		else if (cnt == CNT_MAX)
			cnt <= 25'd0;
		else
			cnt = cnt + 1'b1;
	
	always@(posedge Clk or negedge Rst_n)
		if (Rst_n == 1'b0)
			led <= 1'b1;
		else if (cnt == CNT_MAX)
			led <= ~led;
		else 
			led <= led;

endmodule
			
	