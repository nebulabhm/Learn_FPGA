module MUX2(Clk, Rst_n, Send_En, bps_cnt, UART_state);

	input Clk;
	input Rst_n;
	input Send_En;
	input [3:0] bps_cnt;
	
	output UART_state;
	
	reg UART_state;
	always@(posedge Clk or negedge Rst_n)
		if (!Rst_n)
			UART_state <= 1'b0;
		else if (Send_En)
			UART_state <= 1'b1;
		else if (bps_cnt == 4'd11)
			UART_state <= 1'b0;
		else
			UART_state <= UART_state;

endmodule
