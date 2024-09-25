module id (mclk,led_7s);
input mclk;
output [11:0] led_7s;

reg [11:0] led_7s;
reg [1:0] state;
reg [8:0] i;
reg clk;

always @ (posedge mclk)
begin
	i=i+1;
	clk=i[8];
end

always @ (posedge clk)
case (state)
2'b00: begin
		led_7s=12'b1001_1100_0001;//c,×î×ó²àµÄµÆµãÁÁ
		state=state+1;
		end
2'b01: begin
		led_7s=12'b1001_1110_0010;//e
		state=state+1;
		end
2'b10: begin
		led_7s=12'b1111_1100_0100;//0
		state=state+1;
		end
2'b11: begin
		led_7s=12'b0110_0000_1000;//1
		state=state+1;
		end
endcase
endmodule

		