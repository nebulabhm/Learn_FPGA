module Div_cnt(Clk, Rst_n, UART_state, bps_DR, bps_clk);

	input Clk;
	input Rst_n;
	input UART_state;
	input [15:0] bps_DR;
	
	output bps_clk;
	
	
	reg bps_clk;			//波特率时钟
	reg [15:0] div_cnt;	//分频记数最大值
	always@(posedge Clk or negedge Rst_n)
		if (!Rst_n)
			div_cnt <= 16'd0;
		else if (UART_state)
			begin
				if (div_cnt == bps_DR)
					div_cnt <= 16'd0;
				else
					div_cnt <= div_cnt + 1'b1;
			end
		else
			div_cnt <= 16'd0;
		
	always@(posedge Clk or negedge Rst_n)
		if (!Rst_n)
			bps_clk <= 1'b0;
		else if (div_cnt == 16'd1)
			bps_clk <= 1'b1;
		else
			bps_clk <= 1'b0;
	
endmodule

