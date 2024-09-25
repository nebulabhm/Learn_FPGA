module rom_ip_top(Clk, Rst_n, q);

	input Clk;
	input Rst_n;
	
	output [7:0] q;	
	
	reg [7:0] address;
	wire [7:0] q;
	
	rom rom(
		.address(address),
		.clock(Clk),
		.q(q)
	);
	
	always@(posedge Clk or negedge Rst_n)
	begin
		if (!Rst_n)
			address <= 8'd0;
		else 
			address <= address + 1'b1;
	end

endmodule
