module div(clk50m,clk1_8m);
input clk50m;
output clk1_8m;

reg [12:0] acc ;           // 13 bits total!

always @(posedge clk50m)
  acc <= acc[11:0] + 151; // use only 12 bits from the previous result, but save the full 13 bits

wire clk1_8m = acc[12];   // so that the 13th bit is the carry-out 

endmodule

