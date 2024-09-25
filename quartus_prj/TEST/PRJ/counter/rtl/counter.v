module counter(Clk50M, Rst_n, sync1, sync2, sync3, osc1, osc2, osc3);
	input Clk50M;
	input Rst_n;
	output reg sync1, sync2, sync3;
	output wire osc1, osc2, osc3;
		
	reg[28:0] cnt;
	
	always@(posedge Clk50M or negedge Rst_n)
		if (Rst_n == 1'b0)
			cnt <= 28'd0;
		else if (cnt <= 2)
			begin
				cnt <= cnt + 1'b1;
			end	
			
	always@(negedge Clk50M or negedge Rst_n)
		if (Rst_n == 1'b0)
			begin
				sync1 <= 1'b0;
				sync2 <= 1'b0;
				sync3 <= 1'b0;
			end
		else if (cnt == 28'd1)
			begin
				sync1 <= 1'd1;
				sync2 <= 1'd1;
				sync3 <= 1'd1;
			end
		else if (cnt == 28'd2)
			begin
				sync1 <= 1'd0;
				sync2 <= 1'd0;
				sync3 <= 1'd0;
			end

		
//	always@(posedge Clk50M or negedge Rst_n)
//		if (Rst_n == 1'b0)
//			cnt <= 28'd0;
//		else if (cnt >= 28'd39_999_999)
//			cnt <= 28'd0;
//		else
//			begin
//				cnt <= cnt + 1'b1;
//			end
//	
//	always@(negedge Clk50M or negedge Rst_n)
//		if (Rst_n == 1'b0)
//			begin
//				sync1 <= 1'b0;
//				sync2 <= 1'b0;
//			end
//		else if (cnt == 28'd39_999_999)
//			begin
//				sync1 <= ~sync1;
//				sync2 <= ~sync2;
//			end
//		else if (cnt == 1'b0)
//			begin
//				sync1 <= ~sync1;
//				sync2 <= ~sync2;
//			end
//		else
//			begin
//				sync1 <= sync1;
//				sync2 <= sync2;
//			end
			
	assign osc1 = Clk50M;
	assign osc2 = Clk50M;
	assign osc3 = Clk50M;

endmodule
			
	