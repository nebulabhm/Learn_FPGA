module div_256 (mclk,reset,clk);

input mclk,reset;

output clk;

reg clk;
reg [6:0] count;

always @ (posedge mclk or negedge reset)
begin
	if(!reset)
	count=0;
	else 
	begin
		count=count+1;
		clk=count[6];
	end
end
endmodule

