module sync_oscillator(Clk50M, Rst_n, led);
	input Clk50M;
	input Rst_n;
	output reg led;
	
	reg[3:0] cnt;
	
	always@(posedge Clk50M or negedge Rst_n)
		if (Rst_n == 1'b0)
			cnt <= 4'd0;
		else if (cnt == 4'd249999999)
			cnt <= 4'd0;
		else
			begin
				cnt = cnt + 1'b1;
			end
	
	always@(posedge Clk50M or negedge Rst_n)
		if (Rst_n == 1'b0)
			led <= 1'b0;
		else if (cnt == 4'd249999999)
			led <= ~led;
		else 
			led <= led;

endmodule
			
	