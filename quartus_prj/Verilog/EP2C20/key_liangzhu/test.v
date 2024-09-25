module test(
       sys_clk   ,
       rst_n       ,
	     sp        
	                );
 output	        sp;
 
 input          sys_clk,rst_n ;
 
 
 
 
 reg [24:0] Mega_cnt;
 wire       clk;
/**************************************/
reg     [23:0]   clk_cnt;
  always @ ( posedge sys_clk or negedge rst_n)
    if (!rst_n )
        clk_cnt <= 24'd0;
    else
        clk_cnt <= clk_cnt + 1'b1;

  wire  clk_6mhz = clk_cnt[2];
  wire  clk_4hz  = clk_cnt[23];
      
wire    [3:0]   high,med,low;      
wire    [6 :0]      led_w ;
wire    [4 :0]      segcode;
wire    [3 :0]      hex;

song song_inst
    (
    .clk_6mhz   (clk_6mhz), 
    .clk_4hz    (clk_4hz),
    .sp         ( sp    ),
    .high       ( high  ),
    .med        ( med   ),
    .low        ( low   )
    );
endmodule
module song  (clk_6mhz, clk_4hz ,sp,high ,med,low);
input clk_6mhz,clk_4hz;
output sp;
output[3:0]high,med,low;
reg[3:0]high,med,low;
reg[13:0]divider,origin;
reg[7:0]counter;
reg sp;
wire carry;


assign carry=(divider==16383);

always @(posedge clk_6mhz)
begin  if(carry)divider=origin;
       else     divider=divider+1;
end

always@(posedge carry)
  begin
     sp =~sp;
  end
  
  
  always@(posedge clk_4hz)
   begin
     case({high ,med ,low})
     'b000000000011:   origin=7281;
     'b000000000101:   origin=8730;
     'b000000000110:   origin=9565;
     'b000000000111:   origin=10310;
     'b000000010000:   origin=10647;
     'b000000100000:   origin=11272;
     'b000000110000:   origin=11831;
     'b000001010000:   origin=12556;
     'b000001100000:   origin=12974;
     'b000100000000:   origin=13516;
     'b000000000000:   origin=16383;
     endcase
  end
  
  
  always@(posedge clk_4hz)
     begin
       if(counter==50)      counter=0;
       else  counter=counter+1;
       case(counter)             
       0:  {high,med,low}='b000000000011;
       
 
  1:  {high,med,low}='b000000000011; 
  2:  {high,med,low}='b000000000011;   
  3:  {high,med,low}='b000000000011;
  4:  {high,med,low}='b000000000101;
  5:  {high,med,low}='b000000000101;
  6:  {high,med,low}='b000000000101;
  7:  {high,med,low}='b000000000110;
  8:  {high,med,low}='b000000010000;
  9:  {high,med,low}='b000000010000;
 10:  {high,med,low}='b000000010000;
 11:  {high,med,low}='b000000100000;
 12:  {high,med,low}='b000000000110;
 13:  {high,med,low}='b000000010000;
 14:  {high,med,low}='b000000000101;
 15:  {high,med,low}='b000000000101; 
  
 16:  {high,med,low}='b000001010000; 
 17:  {high,med,low}='b000001010000;   
 18:  {high,med,low}='b000001010000;
 19:  {high,med,low}='b000100000000;
 20:  {high,med,low}='b000001100000;
 21:  {high,med,low}='b000001010000;
 22:  {high,med,low}='b000000110000;
 23:  {high,med,low}='b000001010000;
 24:  {high,med,low}='b000000100000;
 25:  {high,med,low}='b000000100000;
 26:  {high,med,low}='b000000100000;
 27:  {high,med,low}='b000000100000;
 28:  {high,med,low}='b000000100000;
 29:  {high,med,low}='b000000100000;
 30:  {high,med,low}='b000000100000;     
 31:  {high,med,low}='b000000100000; 
 
 
 32:  {high,med,low}='b000000100000;   
 33:  {high,med,low}='b000000100000;
 34:  {high,med,low}='b000000100000;
 35:  {high,med,low}='b000000110000;
 36:  {high,med,low}='b000000000111;
 37:  {high,med,low}='b000000000111;
 38:  {high,med,low}='b000000000110;
 39:  {high,med,low}='b000000000110;
 40:  {high,med,low}='b000000000101;
 41:  {high,med,low}='b000000000101;
 42:  {high,med,low}='b000000000101;
 43:  {high,med,low}='b000000000110;
 44:  {high,med,low}='b000000010000;
 45:  {high,med,low}='b000000010000;
 46:  {high,med,low}='b000000100000;
 47:  {high,med,low}='b000000100000;
 default:{high,med,low}='d0;
 
 //后边乐曲片断此处省略
   endcase
end
endmodule  