module hello(Clk, Rst_n, data, led);
	
	input Clk;
	input Rst_n;
	input [7:0] data;
	output reg led;

	localparam
		CHECK_H = 5'b0_0001,
		CHECK_e = 5'b0_0010,
		CHECK_la = 5'b0_0100,
		CHECK_lb = 5'b0_1000,
		CHECK_o = 5'b1_0000;
	
	reg [4:0] state;
	always@(posedge Clk or negedge Rst_n)
		if (!Rst_n) begin
			led <= 1'b1;
			state <= CHECK_H;
		end
		else begin
			case (state)
				//code...
				CHECK_H:
					if (data === "H")
						state	<= CHECK_e;
					else 
						state <= CHECK_H;
				CHECK_e:
					if (data == "e")
						state <= CHECK_la;
					else	if (data == "H")
						state <= CHECK_e;
					else
						state <= CHECK_H;
				CHECK_la:
					if (data == "l")
						state <= CHECK_lb;
					else if (data == "H")
						state <= CHECK_e;
					else
						state <= CHECK_H;
				CHECK_lb:
					if (data == "l")
						state <= CHECK_o;
					else if (data == "H")
						state <= CHECK_e;
					else
						state <= CHECK_H;
				CHECK_o:
					if (data == "H")
						state <= CHECK_e;
					else 
						begin
							state <= CHECK_H;
							if (data == "o")
								led <= ~led;
							else 
								led <= led;
						end
				default: state <= CHECK_H;
			endcase
		end
	
	
endmodule
