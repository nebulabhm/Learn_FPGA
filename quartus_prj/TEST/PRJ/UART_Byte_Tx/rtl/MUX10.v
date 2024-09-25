module MUX10(Clk, Rst_n, bps_cnt, r_Data_Byte, Rs232_Tx);

	input Clk;
	input Rst_n;
	input [3:0] bps_cnt;
	input [7:0] r_Data_Byte;
	
	output Rs232_Tx;
	reg Rs232_Tx;
	
	localparam START_BIT = 1'b0;
	localparam STOP_BIT = 1'b1;
	always@(posedge Clk or negedge Rst_n)
		if (!Rst_n)
			Rs232_Tx <= 1'b1;
		else
			begin
				case (bps_cnt)
					0: Rs232_Tx <= 1'b1;
					1: Rs232_Tx <= START_BIT;
					2: Rs232_Tx <= r_Data_Byte[0];
					3: Rs232_Tx <= r_Data_Byte[1];
					4: Rs232_Tx <= r_Data_Byte[2];
					5: Rs232_Tx <= r_Data_Byte[3];
					6: Rs232_Tx <= r_Data_Byte[4];
					7: Rs232_Tx <= r_Data_Byte[5];
					8: Rs232_Tx <= r_Data_Byte[6];
					9: Rs232_Tx <= r_Data_Byte[7];
					10: Rs232_Tx <= STOP_BIT;
					default: Rs232_Tx <= 1'b1;
				endcase
			end
endmodule
