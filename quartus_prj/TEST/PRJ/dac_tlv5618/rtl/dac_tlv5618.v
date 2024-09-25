`timescale 1ns/1ns

module dac_tlv5618(
    Clk,   // clock 50MHz
    Rst_n, // module reset

    Start,
    Dac_data,
    Set_done,

    CS_N,  // TLV5618 chip select
    DIN,   // data in
    SCLK,  // serial clock
    DAC_STATE
    );

    parameter fCLK = 50;
    parameter DIV_PARAM = 2;

    input Clk;
    input Rst_n;
    input Start;
    input [15:0]Dac_data;

    output reg Set_done;
    output reg CS_N;
    output reg DIN;
    output reg SCLK;
    output DAC_STATE;

    assign DAC_STATE = CS_N;

    wire trans_done;    // signal of transformal final

    reg [15:0]r_Dac_data;
    reg [3:0]DIV_CNT;   // division frequencial counter
    reg [5:0]SCLK_GEN_CNT;  // SCLK generate serial machine counter
    reg SCLK2X; // 2 fold SCLK sample clock
    reg en; // transfomation enable signal

    // generate enable signal
    always@(posedge Clk or negedge Rst_n)
    if (!Rst_n)
    	en <=   1'b0;
    else if (Start)
    	en <=  1'b1;
    else if (trans_done)
    	en <=  1'b0;
    else
    	en <=  en;

    // generate 2xSCLK numerator
    always@(posedge Clk or negedge Rst_n)
    if (!Rst_n)
    	DIV_CNT <=  4'd0;
    else if (en)
	begin
		if (DIV_CNT == (DIV_PARAM - 1'b1))
                            DIV_CNT <=  4'd0;
		else
                            DIV_CNT <=  DIV_CNT + 1'b1;
	end
    else
    	DIV_CNT <=  4'd0;

    // generate 2x SCLK
    always@(posedge Clk or negedge Rst_n)
    if (!Rst_n)
    	SCLK2X <=  1'b0;
    else if (en && (DIV_CNT == (DIV_PARAM - 1'b1)))
    	SCLK2X <=  1'b1;
    else
    	SCLK2X <=  1'b0;

    // count when enable transformation
    always@(posedge Clk or negedge Rst_n)
    if (!Rst_n)
    	SCLK_GEN_CNT <=  6'd0;
    else if (SCLK2X && en)
	begin
                if (SCLK_GEN_CNT == 6'd33)
                    SCLK_GEN_CNT <=  6'd0;
                else
                    SCLK_GEN_CNT <=  SCLK_GEN_CNT + 1'b1;
	end
    else
    	SCLK_GEN_CNT <=  SCLK_GEN_CNT;

    // 寄存DAC_DATA的值
    always@(posedge Clk or negedge Rst_n)
    if (!Rst_n)
        r_Dac_data <=  16'd0;
    else if (Start) // 收到开始发送命令时，寄存DAC_DATA值
        r_Dac_data <=  Dac_data;
    else
        r_Dac_data <=  r_Dac_data;

    // move data into DAC
    always@(posedge Clk or negedge Rst_n)
    if (!Rst_n)
    	begin
    		DIN  <=  1'b1;
    		SCLK <=  1'b0;
    		CS_N <=  1'b1;
    	end
    else if (!Set_done && SCLK2X)
    	begin
    		case (SCLK_GEN_CNT)
    			0:
    				begin
    					CS_N <=  1'b0;
    					DIN  <=  r_Dac_data[15];
    					SCLK <=  1'b1;
    				end
    			1,3,5,7,9,11,13,15,17,19,21,23,25,27,29,31:
    				begin
    					SCLK <=  1'b0;
    				end
    			2:
    				begin
    					DIN  <=  r_Dac_data[14];
    					SCLK <=  1'b1;
    				end
    			4:
    				begin
    					DIN  <=  r_Dac_data[13];
    					SCLK <=  1'b1;
    				end
    			6:
    				begin
    					DIN  <=  r_Dac_data[12];
    					SCLK <=  1'b1;
    				end
    			8:
    				begin
    					DIN  <=  r_Dac_data[11];
    					SCLK <=  1'b1;
    				end
    			10:
    				begin
    					DIN  <=  r_Dac_data[10];
    					SCLK <=  1'b1;
    				end
    			12:
    				begin
    					DIN  <=  r_Dac_data[9];
    					SCLK <=  1'b1;
    				end
    			14:
    				begin
    					DIN  <=  r_Dac_data[8];
    					SCLK <=  1'b1;
    				end
    			16:
    				begin
    					DIN  <=  r_Dac_data[7];
    					SCLK <=  1'b1;
    				end
    			18:
    				begin
    					DIN  <=  r_Dac_data[6];
    					SCLK <=  1'b1;
    				end
    			20:
    				begin
    					DIN  <=  r_Dac_data[5];
    					SCLK <=  1'b1;
    				end
    			22:
    				begin
    					DIN  <=  r_Dac_data[4];
    					SCLK <=  1'b1;
    				end
    			24:
    				begin
    					DIN  <=  r_Dac_data[3];
    					SCLK <=  1'b1;
    				end
    			26:
    				begin
    					DIN  <=  r_Dac_data[2];
    					SCLK <=  1'b1;
    				end
    			28:
    				begin
    					DIN  <=  r_Dac_data[1];
    					SCLK <=  1'b1;
    				end
    			30:
    				begin
    					DIN  <=  r_Dac_data[0];
    					SCLK <=  1'b1;
    				end
    			32: SCLK <=  1'b1;
    			33: CS_N <=  1'b1;
    			default:;
    		endcase
    	end

    assign trans_done = (SCLK_GEN_CNT == 33) && SCLK2X;

    always@(posedge Clk or negedge Rst_n)
    if (!Rst_n)
    	Set_done <= 1'b0;
    else if (trans_done)
    	Set_done <= 1'b1;
    else
    	Set_done <= 1'b0;


    endmodule
