module DR_LUT(Clk, Rst_n, Baud_set, bps_DR);

	input Clk;
	input Rst_n;
	input [2:0] Baud_set;
	
	output [15:0] bps_DR;
	
	reg [15:0] bps_DR;	//分频记数最大值
	always@(posedge Clk or negedge Rst_n)
		if (!Rst_n)
			bps_DR <= 16'd5207;
		else
			begin
				case (Baud_set)
					0: bps_DR <= 16'd5207;	//9 600 bps
					1: bps_DR <= 16'd2603;	//19 200bps
					2: bps_DR <= 16'd1301;	//38 400 bps
					3: bps_DR <= 16'd867;	//57 600 bps
					4: bps_DR <= 16'd433;	//115 200 bps
					default: bps_DR <= 16'd5207;
				endcase
			end
		
endmodule
