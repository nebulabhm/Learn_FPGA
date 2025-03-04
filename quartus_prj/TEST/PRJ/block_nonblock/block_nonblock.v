module block_nonblock(Clk, Rst_n, a, b, c, out);

	input Clk;
	input Rst_n;
	input a,b,c;
	output reg [1:0] out;

	reg[1:0] d;
	always @(posedge Clk or negedge Rst_n)
		if (!Rst_n)
			out = 2'b0;
		else begin
			//d <= a + b;
			//out <= d + c;
			//d = a + b;
			//out = d + c;
			out <= a + b + c;
		end
endmodule
