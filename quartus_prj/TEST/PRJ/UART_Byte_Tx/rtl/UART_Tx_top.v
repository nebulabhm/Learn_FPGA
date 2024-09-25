module UART_Tx_top(
	Clk, 
	Rst_n, 
	key_in, 

	Rs232_Tx, 
	led
	);
	
	input Clk;
	input Rst_n;
	input key_in;
	
	output Rs232_Tx; 
	output led;
	
	reg Rs_232_TX;

	
	wire key_flag0;
	wire key_state0;

	wire [7:0] Data_Byte;	
	wire Send_En;
	wire led;
	
	hex_data hex_data(
		.probe(),
		.source(Data_Byte)
	);

	key_stable key_stable0(
		.Clk(Clk), 
		.Rst_n(Rst_n), 
		.key_in(key_in),
		
		.key_flag(key_flag0), 
		.key_state(key_state0)
	);
	
	assign Send_En = key_flag0 & !key_state0;	// 组合逻辑复制语句左边必须是wire型
	UART_Byte_Tx UART_Byte_Tx0(
		.Clk(Clk), 
		.Rst_n(Rst_n), 
		.Data_Byte(Data_Byte), 
		.Send_En(Send_En), 
		.Baud_set(3'd0),
		
		.Rs232_Tx(Rs232_Tx), 
		.Tx_Done(), 
		.UART_state(led)
	);

endmodule
