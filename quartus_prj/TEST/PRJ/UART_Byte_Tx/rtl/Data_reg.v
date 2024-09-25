module Data_reg(Clk, Rst_n, Send_En, Data_Byte, r_Data_Byte);

	input Clk;
	input Rst_n;
	input Send_En;
	input [7:0] Data_Byte;
	
	output [7:0] r_Data_Byte;
	 
	reg [7:0] r_Data_Byte;
	always@(posedge Clk or negedge Rst_n)
		if (!Rst_n)
			r_Data_Byte <= 8'd0;
		else if (Send_En)
			r_Data_Byte <= Data_Byte;
		else 
			r_Data_Byte <= r_Data_Byte;
	
endmodule
