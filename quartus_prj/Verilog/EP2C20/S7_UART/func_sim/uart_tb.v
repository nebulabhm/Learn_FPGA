`timescale 1ns/1ns

module UART_tb;

wire tbre;
wire tsre;
wire sdo ;
wire rxd;

reg [7:0] din;
reg rst ;
reg clk16x ;
reg wrn;
reg rdn;

wire [7:0] dout;
wire data_ready;
wire framing_error ;
wire parity_error ;

    uart PC (.dout(dout),
             .data_ready(data_ready),
             .framing_error(framing_error),
             .parity_error(parity_error),
             .rxd(rxd),
             .clk16x(clk16x),
             .rst(rst),
             .rdn(rdn),
             .din(din),
             .tbre(tbre),
             .tsre(tsre),
             .wrn(wrn),
             .sdo(sdo)
             ) ;

    uart_if FPGA (.clk(clk16x),
	            .rst_n(~rst),
				.txd(rxd),
				.rxd(sdo)
				);
    // Enter fixture code here

    initial begin
        din = 0;
        rst = 0;
        clk16x = 0;
        wrn = 1;
	rdn = 1;
    end

always #10 clk16x = ~clk16x ;

initial begin
#3 rst = 1'b1 ;
din ="R";// 8'b11110000 ;
#5000 rst = 1'b0 ;
#30 wrn = 1'b0 ;
#150 wrn = 1'b1 ;
//#4000 din ="r"; // 8'b10101010 ;
//#870 wrn = 1'b0 ;
//#200 wrn = 1'b1 ;

#104000 din ="r"; // 8'b10101010 ;
#870 wrn = 1'b0 ;
#200 wrn = 1'b1 ;

end


always @(posedge data_ready)
begin
  #100 rdn=0;
  #500 rdn=1;
end

endmodule // Uart_tb
