module UART_Byte_Tx(Clk, Rst_n, Data_Byte, Send_En, Baud_set, Rs232_Tx, Tx_Done, UART_state);

	input Clk;
	input Rst_n;
	input [7:0] Data_Byte;
	input Send_En;
	input [2:0] Baud_set;
	
	output Rs232_Tx; 
	output Tx_Done;
	output UART_state;
	
	wire Rs232_Tx;
	wire Tx_Done;
		
	wire [15:0] bps_DR;
	wire bps_clk;
	wire [3:0] bps_cnt;
	wire [7:0] r_Data_Byte;
	wire UART_state;
	
	DR_LUT DR_LUT0(
		.Clk(Clk), 
		.Rst_n(Rst_n), 
		.Baud_set(Baud_set), 
		.bps_DR(bps_DR)
	);
		
	Div_cnt Div_cnt0(
		.Clk(Clk), 
		.Rst_n(Rst_n), 
		.UART_state(UART_state), 
		.bps_DR(bps_DR), 
		.bps_clk(bps_clk)
	);
	
	bps_cnt bps_cnt0(
		.Clk(Clk),
		.Rst_n(Rst_n), 
		.bps_clk(bps_clk), 
		.bps_cnt(bps_cnt), 
		.Tx_done(Tx_Done)
	);
	
	MUX2 MUX20(
		.Clk(Clk), 
		.Rst_n(Rst_n), 
		.Send_En(Send_En), 
		.bps_cnt(bps_cnt), 
		.UART_state(UART_state)
	);
	
	Data_reg Data_reg0(
		.Clk(Clk), 
		.Rst_n(Rst_n), 
		.Send_En(Send_En), 
		.Data_Byte(Data_Byte), 
		.r_Data_Byte(r_Data_Byte)
	);
	
	MUX10 MUX100(
		.Clk(Clk), 
		.Rst_n(Rst_n), 
		.bps_cnt(bps_cnt), 
		.r_Data_Byte(r_Data_Byte),
		.Rs232_Tx(Rs232_Tx)
	);



endmodule
