`timescale 1ns / 1ns
`define CLOCK_PERIOD 20 
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/09/05 11:38:38
// Design Name: 
// Module Name: bin_counter_tb
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


module bin_counter_tb( );
    reg clk;
    reg reset_n;
    wire led;
    bin_counter bin_counter_inst(
    .clk(clk),
    .reset_n(reset_n),
    .led(led)
    );
    
    initial clk = 1;
    always #(`CLOCK_PERIOD/2) clk = ~clk;
    
    defparam bin_counter_inst.MCNT = 24_999;
    initial begin
        reset_n = 1'b0;
        #(`CLOCK_PERIOD * 200 + 1);
        reset_n = 1'b1;
        #2000000000;
        $stop;
     end
     
endmodule
