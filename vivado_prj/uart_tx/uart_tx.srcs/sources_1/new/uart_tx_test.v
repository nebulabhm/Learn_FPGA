
//////////////////////////////////////////////////////////////////////////////////
// Company: 武汉芯路恒科技有限公司
// Engineer: www.corecourse.cn
// 
// Create Date: 2021/09/20 00:00:00
// Design Name: uart_tx
// Module Name: uart_tx_test
// Project Name: uart_tx
// Target Devices: xc7z020clg400-2
// Tool Versions: Vivado 2018.3
// Description: 串口发送上板测试顶层
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps
module uart_tx_test(
	clk,
	reset_n,

	uart_tx,
	led
);
    wire reset;
	assign reset=~reset_n;

	input clk; //系统时钟输入，50M
	input reset_n; //复位信号输入，低有效

	output uart_tx; //串口输出信号
	output led;     //led指示数据发送状态
	
	wire send_en;    //发送使能
	wire [7:0]data_byte;  //待传输8bit数据
	wire test_en;    //按键标志信号
	reg test_en_dly1;
	reg test_en_dly2;

	always@(posedge clk)
	begin
		test_en_dly1 <= test_en;
		test_en_dly2 <= test_en_dly1;
	end

  //VIO输出测试信号控制发送使能
	assign send_en = test_en_dly1 & !test_en_dly2;

  //使用vio设置串口发送数据
	vio_0 vio_0 (
		.clk(clk),  // input wire clk
		.probe_out0(test_en),  // output wire [0 : 0] probe_out0
		.probe_out1(data_byte)   // output wire [7 : 0] probe_out1
	);

	uart_byte_tx uart_byte_tx(
		.clk(clk),
		.reset_n(reset_n),

		.data_byte(data_byte),
		.send_en(send_en),
		.baud_set(3'd0),
		
		.uart_tx(uart_tx),
		.tx_done( ),
		.uart_state(led)
	);	

endmodule
