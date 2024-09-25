`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/08/29 11:40:24
// Design Name: 
// Module Name: led_flash
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


module led_flash(
    input clk,
    input rst_n,
    output reg led
    );
    reg [25:0] cnt; 
    always @ (posedge clk or negedge rst_n) 
    begin 
    if (!rst_n) 
    cnt <= 26'd0; 
    else if (cnt < 26'd49_999_999) 
    cnt <= cnt + 1'b1; 
    else 
    cnt <= 26'd0; 
    end 
     
    always @ (posedge clk or negedge rst_n) 
    begin 
    if (!rst_n) 
    led <= 1'b0; 
    else if (cnt == 26'd49_999_999) 
    led <= ~led; 
    else 
    led <= led; 
    end
endmodule
