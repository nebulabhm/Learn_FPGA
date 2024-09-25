module sram_test( rst        ,
                  clkin      ,
                             
                  sram_ab    ,
                  sram_db    ,
                  sram_wr    ,
                  sram_rd    ,            
                  sram_cs    ,
           		  error,
                  task_start , //Start    Testing ---LED1
                  task_finish,  //Testing  Finish  ---LED2
				  flash_ce,
				  flash_oe,
				  flash_we
                 );
 input           rst       ;
 input           clkin     ;
 
 output [18:0]   sram_ab   ;
 inout  [7:0]   sram_db   ;

 output          sram_wr   ;
 output          sram_rd   ;
 output          sram_cs   ;
output error;
 output          task_start ;
 output          task_finish;        
 output			 flash_ce,flash_oe,flash_we;
 //ports
 wire            rst       ;  
 wire            clkin     ;  
                              
 reg    [18:0]   sram_ab   ;  
 wire   [7:0]   sram_db   ;  
 reg             sram_wr   ;  
 reg             sram_rd   ;  
                              
 reg             task_start ; 
 reg             task_finish; 
 wire flash_ce=1;
 wire flash_oe=1;
 wire flash_we=1;
 //internal signals
 reg             clk_2;
 wire            clk;

 reg  [2:0]      STATE,NEXT;
 reg             error     ;
 reg  [7:0]     sram_db_reg;
 reg  [7:0]     count      ;

 //parameters
 parameter     IDLE     = 3'D0,
               WRITE_1  = 3'D1,
               WRITE_2  = 3'D2,
               READ_1   = 3'D3,
               READ_2   = 3'D4;
 
 assign  sram_cs = 1'b0;
 assign  sram_db = sram_rd ? sram_db_reg:'hz;
 
 reg [1:0] clk_count;
 always @(posedge clkin or negedge rst)
	if(!rst)
		begin
			clk_count<=2'd0;
		end
	else
 		begin
   			clk_count<=clk_count+1'b1;
 		end 
 assign clk = clk_count[1];


//state machine              
 always @ (STATE or sram_ab or error or task_start)
 begin
     case(STATE)
     IDLE    : if(task_start)
                   NEXT = WRITE_1;
               else
                   NEXT = IDLE   ;
     WRITE_1 : NEXT = WRITE_2;
     WRITE_2 : if( sram_ab >= 19'h7ffff)
                   NEXT = READ_1;
               else
                   NEXT = WRITE_1;
     READ_1  : NEXT = READ_2;
     READ_2  : if(  sram_ab >= 19'h7ffff)//error ||
                   NEXT = IDLE;
               else
                   NEXT = READ_1;
     default : NEXT = IDLE ;
     endcase
 end
 
 //registe the state
 always @ (posedge clk or negedge rst)
 if(!rst)
    STATE <= IDLE;
 else
    STATE <= NEXT;
 
 
 always @ (posedge clk or negedge rst)
 if(!rst)
    begin
        sram_ab      <=19'h7ffff;
        sram_db_reg  <=8'hff;
        sram_wr      <=1'b1;
        sram_rd      <=1'b1;
    end
 else
    case(STATE)
    IDLE    : begin
                  sram_rd     <= 1;
                  sram_wr     <= 1;
              end
    WRITE_1 : begin
                  sram_ab     <= sram_ab+1;
                  sram_db_reg <= sram_db_reg+1;
                  sram_wr     <= 1'b0;
                  sram_rd     <= 1'b1;  
              end
    WRITE_2 : begin
                  sram_wr  <= 1'b1;
                  sram_rd  <= 1'b1;
     //             if( sram_ab >= 18'h3ffff)
     //                  sram_ab <= 18'h3ffff;
              end
    READ_1  : begin
                  sram_ab <= sram_ab+1;
                  sram_wr <= 1'b1;
                  sram_rd <= 1'b0;
                  sram_db_reg <= 8'hff;
              end
    endcase


always @ (posedge clk or negedge rst)      
if(!rst)                                     
   begin                                     
       error      <= 1'b0;
       task_start <= 1'b1;
       task_finish<= 1'b0;
       count      <= 8'hff;                           
   end                                       
else                                         
   case(STATE) 
                      
   WRITE_1 : //if( sram_ab < 'd1024 )
               begin                           
                    task_start <= 1'b1;
                    count      <= 8'hff; 
               end
   READ_1  : begin
                 count<=count+1;
             end                                                                
   READ_2  : begin                           
                 if( sram_db != count)
                     error <= 1'b1;
                  else
                    begin                       
                       error <= 1'b0;
                       if(sram_ab >= 19'h7ffff)
                          begin
                             task_finish <= 1'b1;
                             //task_start  <= 1'b1;
                          end
                    end              
             end                             
   endcase                                   
  
endmodule           
            
 