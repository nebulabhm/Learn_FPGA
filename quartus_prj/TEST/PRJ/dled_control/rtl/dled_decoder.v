module dled_decoder(sel_r, disp_data, data_tmp);

	input [7:0] sel_r;
	input [31:0] disp_data;
	output data_tmp;
	
	reg [3:0] data_tmp;
	always@(*)
		case (sel_r)
			8'b0000_0001: data_tmp = disp_data[3:0];
			8'b0000_0010: data_tmp = disp_data[7:4];
			8'b0000_0100: data_tmp = disp_data[11:8];
			8'b0000_1000: data_tmp = disp_data[15:12];
			8'b0001_0000: data_tmp = disp_data[19:16];
			8'b0010_0000: data_tmp = disp_data[23:20];
			8'b0100_0000: data_tmp = disp_data[27:24];
			8'b1000_0000: data_tmp = disp_data[31:28];
			default: data_tmp = 4'b0000;
		endcase


endmodule

