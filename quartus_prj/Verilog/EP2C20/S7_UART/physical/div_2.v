module div_2(inclk, clk2);
input inclk;
output clk2;

reg clk2;

always @(posedge inclk)
clk2<=~clk2;

endmodule
