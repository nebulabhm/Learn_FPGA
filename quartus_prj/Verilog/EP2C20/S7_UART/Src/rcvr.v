/******************************************************************************
*
*    File Name:  rcvr.v
*      Version:  1.1
*         Date:  January 22, 2000
*        Model:  Receiver Chip

******************************************************************************/

`timescale 1 ns / 1 ns

module rcvr (dout,data_ready,framing_error,parity_error,rxd,clk16x,rst,rdn) ;

input rxd ;
input clk16x ;
input rst ;
input rdn ;
output [7:0] dout ;
output data_ready ;
output framing_error ;
output parity_error ;

reg rxd1 ;
reg rxd2 ;
reg clk1x_enable ;
reg [3:0] clkdiv ;
reg [7:0] rsr ;
reg [7:0] rbr ;
reg [3:0] no_bits_rcvd ;

reg data_ready ;

reg parity ;
reg parity_error ;
reg framing_error ;

wire clk1x ;

assign dout = !rdn ? rbr : 8'bz ;

always @(posedge clk16x or posedge rst)
begin
if (rst)
begin
rxd1 <= 1'b1 ;
rxd2 <= 1'b1 ;
end
else 
begin
rxd1 <= rxd ;
rxd2 <= rxd1 ;
end
end

always @(posedge clk16x or posedge rst)
begin
if (rst)
clk1x_enable <= 1'b0;
else if (!rxd1 && rxd2)
clk1x_enable <= 1'b1 ;
else if (no_bits_rcvd == 4'b1100)
clk1x_enable <= 1'b0 ;
end

always @(posedge clk16x or posedge rst or negedge rdn)
begin
if (rst)
data_ready = 1'b0 ;
else if (!rdn)
data_ready = 1'b0 ;
else
if (no_bits_rcvd == 4'b1011)
data_ready = 1'b1 ;
end

always @(posedge clk16x or posedge rst)
begin
if (rst)
clkdiv = 4'b0000 ;
else if (clk1x_enable)
clkdiv = clkdiv +1 ;
end

assign clk1x = clkdiv[3] ;

always @(posedge clk1x or posedge rst)
if (rst)
begin
rsr <= 8'b0 ;
rbr <= 8'b0 ;
parity <= 1'b1 ;
framing_error = 1'b0 ;
parity_error = 1'b0 ;
end
else 
begin
if (no_bits_rcvd >= 4'b0001 && no_bits_rcvd <= 4'b1000)   //4'b1001
begin
/* MSB First
rsr[0] <= rxd2 ;
rsr[7:1] <= rsr[6:0] ;
parity <= parity ^ rsr[7] ;
*/

/* LSB First */
rsr[7] <= rxd2 ;
rsr[6:0] <= rsr[7:1] ;
parity <= parity ^ rsr[0] ;



end
else if (no_bits_rcvd == 4'b1001)  //4'b1010
begin
rbr <= rsr ;
end
else if (!parity) 
parity_error = 1'b1 ;
else if ((no_bits_rcvd == 4'b1011) && (rxd2 != 1'b1))
framing_error = 1'b1 ;
else
framing_error = 1'b0 ;
end


always @(posedge clk1x or posedge rst or negedge clk1x_enable)
if (rst)
no_bits_rcvd = 4'b0000;
else
if (!clk1x_enable)
no_bits_rcvd = 4'b0000 ;
else
no_bits_rcvd = no_bits_rcvd + 1 ;

endmodule

