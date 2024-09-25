`timescale 1 ns / 1 ns

module uart_if(clk,rst_n,txd,rxd,rom_addr,rom_data);
input       clk,rst_n,rxd;
input[7:0]  rom_data;
output	    txd;
output[7:0] rom_addr;
reg   [7:0] rom_addr;
reg   [7:0] rom_addr_d;

wire tbre;
wire tsre;
wire rst = ~rst_n;
wire clk_16;

reg [7:0] din;
reg wrn;
reg rdn,rdn_d,rdn_d2;

wire [7:0] dout;
wire data_ready;
wire framing_error ;
wire parity_error ;

reg read_en,read_once;

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
	  rom_addr<='h0;
	  rom_addr_d<='h0;	
	  din<=0;	   
	  wrn<=1;
	end
  else
    if(!read_en)
	  begin
	  read_once<=0;
      rom_addr<='h0;
	  rom_addr_d<='h0;
	  wrn<=1;
	  end
	else
      begin
      if((!tbre) && (!read_once) && tsre)
	     begin
	     wrn<=0;
         din<=rom_data;
	     if(rom_addr_d>='h7f)
		   begin
	       read_once<=1;
		   end
	     else
	       rom_addr_d<=rom_addr_d+1;
	       rom_addr<=rom_addr_d;			  
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
	rdn_d2<=1;
    rdn<=1;
	end
  else
  if(data_ready)
     begin
     rdn_d<=0;
	 rdn<=rdn_d;
	 rdn_d2<=rdn_d;
	 end
  else
     begin
     rdn_d<=1;
	 rdn_d2<=rdn_d;
	 rdn<=rdn_d2;
	 end
end


always @(posedge clk_16 or negedge rst_n)
begin
  if(!rst_n)
    begin
	read_en<='b1;
	end
  else
   if(!rdn)
	 begin
	  read_en<=(dout=='h72)? 1 : 0;
 	 end
   else
     if(rom_addr >= 'h7f)
	   begin
	   read_en  <= 0;
	   end
end


endmodule // Uart_tb
