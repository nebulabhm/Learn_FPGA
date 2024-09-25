`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/08/29 11:40:24
// Design Name: 
// Module Name: bin_counter
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module bin_counter(
    input clk,
    input reset_n,
    output reg led
    );
    
    assign reset = ~reset_n;
    parameter MCNT = 24_999_999;
    
    reg [24:0] cnt; //定义计数器寄存器

    //计数器计数过程
    always @ (posedge clk or negedge reset) 
    begin 
    if (reset) 
     cnt <= 25'd0; 
    else if (cnt == MCNT) 
        cnt <= 25'd0;
    else 
        cnt <= cnt + 1'b1; 
    end 
     
     //led输出控制进程
    always @ (posedge clk or negedge reset) 
    begin 
    if (reset) 
        led <= 1'b1; 
    else if (cnt == MCNT) 
        led <= ~led; 
    else 
        led <= led; 
    end
    
    ila_0 ila_0 (
        .clk(clk), // input wire clk
        .probe0(cnt), // input wire [24:0]  probe0  
        .probe1(led) // input wire [0:0]  probe1
        );

endmodule
