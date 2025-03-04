module bps_cnt(Clk, Rst_n, bps_clk, bps_cnt, Tx_done);

	input Clk;
	input Rst_n;
	input bps_clk;
		
	output [3:0] bps_cnt;	//波特率时钟计数器
	output Tx_done;	//发送结束标志
	
	reg [3:0] bps_cnt;
	reg Tx_done;
	always@(posedge Clk or negedge Rst_n)
		if (!Rst_n)
			bps_cnt <= 4'd0;
		else if (bps_cnt == 4'd11)
			bps_cnt <= 4'd0;
		else if (bps_clk)
			bps_cnt <= bps_cnt + 1'b1;
		else
			bps_cnt <= bps_cnt;
	
	always@(posedge Clk or negedge Rst_n)
		if (!Rst_n)
			Tx_done <= 1'b0;
		else if (bps_cnt == 4'd11)
			Tx_done <= 1'b1;
		else
			Tx_done <= 1'b0;
	
endmodule
