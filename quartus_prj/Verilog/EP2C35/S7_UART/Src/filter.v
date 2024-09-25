module filter(clk,rst_in,rst_out);
input   clk,rst_in;
output  rst_out;
reg     rst_out;

wire     clk_r;
reg[15:0] cnt;

always  @(posedge clk)
begin
  cnt <= cnt + 1;
end

assign clk_r = cnt[15];

always  @(posedge clk_r)
begin
  if(rst_in)
     rst_out <= 'b1;
  else
     rst_out <= 'b0;
end

endmodule
 