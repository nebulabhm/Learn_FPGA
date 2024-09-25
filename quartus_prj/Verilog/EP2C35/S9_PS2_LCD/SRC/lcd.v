module lcd(clk,rst,data_in,lcd_e,lcd_rw,lcd_rs,data);
	input clk,rst;
	input [7:0] data_in;
	output lcd_e,lcd_rw,lcd_rs;
	output [7:0] data;
	reg lcd_e,lcd_rw,lcd_rs;
	reg [7:0] data,data_in_buf;
	
	reg [10:0] state;
	reg flag;
	reg [6:0] count;
	
	
	parameter IDLE		=11'b00000000000;
	parameter CLEAR		=11'b00000000001;		//清屏
	
	parameter RETURNCURSOR	=11'b00000000010;	//归home位
	
	parameter SETMODE	=11'b00000000100;		
	//输入方式设置，读写数据后ram地址增/减1；画面动/不动
	
	parameter SWITCHMODE	=11'b00000001000;	
	//显示状态设置，显示开/关；光标开/关；闪烁开/关
	
	parameter SHIFT		=11'b00000010000;		
	//光标画面滚动 画面/光标平移一位；左/右平移一位
	
	parameter SETFUNCTION	=11'b00000100000;	
	//工作方式设置 1：8/1：4位数据接口；两行/一行显示；5x10/5x7点阵
	
	parameter SETCGRAM	=11'b00001000000;		//设置CGRAM
	parameter SETDDRAM	=11'b00010000000;		//设置DDRAM
	parameter READFLAG	=11'b00100000000;		//
	parameter WRITERAM	=11'b01000000000;		//写RAM
	parameter READRAM	=11'b10000000000;		//读RAM

	parameter cur_inc      	=1;
	parameter cur_dec      	=0;
	parameter cur_shift    	=1;
	parameter cur_noshift  	=0;
	parameter open_display 	=1;
	parameter open_cur     	=0;
	parameter blank_cur    	=0;
	parameter shift_display	=1;
	parameter shift_cur    	=0;
	parameter right_shift  	=1;
	parameter left_shift   	=0;
	parameter datawidth8   	=1;
	parameter datawidth4   	=0;
	parameter twoline      	=1;
	parameter oneline      	=0;
	parameter font5x10     	=1;
	parameter font5x7      	=0;

	
	reg [15:0] clkcnt;
	
	always @ (posedge clk)
	if(!rst)
	clkcnt<=16'b0000_0000_0000_0000;
	else
	begin
		if(clkcnt==16'b1001_1100_0100_0000)
			clkcnt<=16'b0000_0000_0000_0000;
		else 
			clkcnt<=clkcnt+1;
	end
	
	wire tc_clkcnt;
	assign tc_clkcnt=(clkcnt==16'b1001_1100_0100_0000)?1:0;
	
	reg clkdiv;
	always @ (posedge tc_clkcnt)
	if(!rst)
		clkdiv<=0;
	else
		clkdiv<=~clkdiv;
	
	reg clk_int;
	always @ (posedge clkdiv)
	if(rst==0)
		clk_int<=0;
	else
		clk_int<=~clk_int;
		
	always @ (negedge clkdiv)
	if(rst==0)
		lcd_e<=0;
	else
		lcd_e<=~lcd_e;
		
		
	always @ (posedge clk_int or negedge rst)
		if(!rst)
		begin
			state<=IDLE;
			flag<=0;
			data_in_buf<=data_in;
		end
		else
		begin 
			case(state)
			IDLE		:begin
							if(flag==0)
							begin
								state<=SETFUNCTION;
								flag<=1;
							end
							else
								state<=SHIFT;
						 end
			CLEAR			:begin lcd_rs<=0;lcd_rw<=0;data<=8'b0000_0001;
									state<=SETMODE;end   
			SETMODE			:begin lcd_rs<=0;lcd_rw<=0;data[7:2]<=6'b000001;data[1]<=cur_inc;data[0]<=cur_noshift;
									state<=SETDDRAM;end
			RETURNCURSOR	:begin lcd_rs<=0;lcd_rw<=0;data<=8'b00000010;
									state<=WRITERAM;end
			SWITCHMODE 		:begin lcd_rs<=0;lcd_rw<=0;data[7:3]<=5'b00001;data[2]<=open_display;data[1]<=open_cur;data[0]<=blank_cur;
								state<=SETMODE;end
			SHIFT			:begin lcd_rs<=0;lcd_rw<=0;data[7:4]<=4'b0001;data[3]<=shift_cur;data[2]<=left_shift;data[1:0]<=2'b00;
								state<=IDLE;end
			SETFUNCTION		:begin lcd_rs<=0;lcd_rw<=0;data[7:5]<=3'b001;data[4]<=datawidth8;data[3]<=twoline;data[2]<=font5x10;data[1:0]<=2'b00;
								state<=SWITCHMODE;end
			SETCGRAM		:begin lcd_rs<=0;lcd_rw<=0;data<=8'b01000000;state<=IDLE;end
			SETDDRAM		:begin 
								if(data_in_buf!=8'b0000_1000&&count<7'b001_0000)
								begin lcd_rs<=0;lcd_rw<=0;data[7]<=1;data[6:0]<=count;count<=count+1;state<=WRITERAM;end
								//在第一行显示，显示后地址加1
								else if (data_in_buf!=8'b0000_1000&&count==7'b001_0000)
								begin lcd_rs<=0;lcd_rw<=0;data[7]<=1;data[6:0]<=7'b100_0000;count<=7'b100_0001;state<=WRITERAM;end
								//第一行满，转换到第二行
								else if (data_in_buf!=8'b0000_1000&&count>7'b100_0000&&count<7'b101_0000)
								begin lcd_rs<=0;lcd_rw<=0;data[7]<=1;data[6:0]<=count;count<=count+1;state<=WRITERAM;end
								//第二行显示
								else begin count<=0;state<=CLEAR;end
								//相对于第二行满的情况或按下backspace（ascii码0000_1000）时，清零
							 end
			WRITERAM		:begin
								lcd_rs<=1;
								lcd_rw<=0;
								data<=data_in_buf;
								state<=SHIFT;
							end
			endcase
		end
endmodule
							
			
			
		
		
