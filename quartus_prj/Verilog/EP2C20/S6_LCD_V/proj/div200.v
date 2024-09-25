module div200(clk,rst,clk_200);
	input clk,rst;
	output clk_200;
	reg clk_200;
	reg[7:0] count;

always @(posedge clk or negedge rst)
begin
	if (!rst)
	begin
		count <= 8'b0000_0001;
		clk_200<=0;
	end
	else
	begin
		if(count==8'b1100_1000)
		begin
			clk_200<=~clk_200;
    		count <=8'b0000_0001; 
		end
		else
			count<=count+1;
	end
end
endmodule