`timescale 1 ns / 1 ns

module uart_if(clk,rst_n,txd,rxd);
input    clk,rst_n,rxd;
output	 txd;


wire tbre;
wire tsre;
wire rst = ~rst_n;
wire clk_16;

reg [7:0] din;
reg wrn;
reg rdn,rdn_d;

wire [7:0] dout;
wire data_ready;
wire framing_error ;
wire parity_error ;



reg[3:0] cnt;

//Uart module
    uart U1 (.dout(dout),
             .data_ready(data_ready),
             .framing_error(framing_error),
             .parity_error(parity_error),
             .rxd(rxd),
             .clk16x(clk),
             .rst(rst),
             .rdn(rdn),
             .din(din),
             .tbre(tbre),
             .tsre(tsre),
             .wrn(wrn),
             .sdo(txd)
             ) ;


always @(posedge clk or negedge rst_n)
begin
  if(!rst_n)
    cnt<=0;
  else
    cnt<=cnt+1;
end


assign clk_16 = cnt[3];

always @(posedge clk_16 or negedge rst_n)
begin
  if(!rst_n)
    begin
	  din<='h40;				 //Fixed Value
	  wrn<=1;
	end
  else
    begin
    if((!tbre))// & tsre)
	   begin
	   wrn<=0;
	   din<=din+1;				 //INC Value
	   end
	else
	 //  if(tbre)// & (!tsre))
	   begin
	   wrn<=1;
	   end

    end    
end  


always @(posedge clk_16 or negedge rst_n)
begin
  if(!rst_n)
    begin
	rdn_d<=1;
    rdn<=1;
	end
  else
  if(data_ready)
     begin
     rdn_d<=0;
	 rdn<=rdn_d;
	 end
  else
     begin
     rdn_d<=1;
	 rdn<=rdn_d;
	 end
end


endmodule // Uart_tb
