`timescale 1ns/1ns
`define clock_period 20

module UART_Byte_Tx_tb;
	
	reg clk;
	reg rst_n;
	reg [7:0] Data_Byte;
	reg Send_En;
	reg [2:0] Baud_set;
	
	wire Rs232_Tx; 
	wire Tx_Done;
	wire UART_state;	
	
	
	UART_Byte_Tx UART_Byte_Tx0(
		.Clk(clk), 
		.Rst_n(rst_n), 
		.Data_Byte(Data_Byte), 
		.Send_En(Send_En), 
		.Baud_set(Baud_set), 
		.Rs232_Tx(Rs232_Tx), 
		.Tx_Done(Tx_Done), 
		.UART_state(UART_state)
	);
		
	initial clk = 1;
	always #(`clock_period/2) clk = ~clk;
	
	initial 
		begin
			rst_n = 1'b0;
			Data_Byte = 8'd0;
			Send_En = 1'd0;
			Baud_set = 3'd4;
			#(`clock_period * 20 + 1);
			rst_n = 1'b1;
			#(`clock_period * 50);
			Data_Byte = 8'haa;
			Send_En = 1'd1;
			#(`clock_period);
			Send_En = 1'd0;
			
			@(posedge Tx_Done)
			
			#(`clock_period * 5000);
			Data_Byte = 8'h55;
			Send_En = 1'd1;
			#(`clock_period);
			Send_En = 1'd0;
			
			@(posedge Tx_Done)
			
			#(`clock_period * 5000);
			$stop;

		end
endmodule
