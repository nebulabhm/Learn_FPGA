/******************************************************************************
*
*    File Name:  uart.v
*      Version:  1.1
*         Date:  January 22, 2000
*        Model:  Uart Chip
* Dependencies:  txmit.v, rcvr.v
**
******************************************************************************/

`timescale 1ns / 100ps

module uart (dout,data_ready,framing_error,parity_error,rxd,clk16x,rst,rdn,din,tbre,tsre,wrn,sdo);

output tbre ;
output tsre ;
output sdo ;
input [7:0] din ;
input rst ;
input clk16x ;
input wrn ;
input rxd ;
input rdn ;
output [7:0] dout ;
output data_ready ;
output framing_error ;
output parity_error ;

rcvr u1 (dout,data_ready,framing_error,parity_error,rxd,clk16x,rst,rdn) ;

txmit u2 (din,tbre,tsre,rst,clk16x,wrn,sdo) ;

endmodule
