//==================================================================================================
//  Filename      : ir_decoder_tb.v
//  Created On    : 2019-07-13 17:04:54
//  Last Modified : 2019-07-13 17:22:10
//  Revision      :
//  Author        : nebulabhm
//  Company       : cg-tech
//  Email         : nebulabhm@gmail.com
//
//  Description   : testbench
//
//
//==================================================================================================
`timescale 1ns/1ns
`define clock_period 20

module ir_decoder_tb;

    reg Clk;
    reg Rst_n;
    reg iIR;

    wire Get_Flag;
    wire [15:0]irData;
    wire [15:0]irAddr;

    integer i;

    IR_remote_controller IR_remote_controller(
        .Clk(Clk),
        .Rst_n(Rst_n),

        .iIR(iIR),

        .Get_Flag(Get_Flag),
        .irData(irData),
        .irAddr(irAddr)
        );

    initial Clk = 1'b1;
    always#(`clock_period/2) Clk = ~Clk;

    initial begin
        Rst_n = 1'b0;
        iIR = 1'b1;
        #(`clock_period*10 +  1'b1);
        Rst_n = 1'b1;

        #2000;
        iIR = 1'b1;
        send_data(1, 8'h12);

        #6000000;
        send_data(3, 8'heb);

        #6000000;
        $stop;
    end

    task send_data;
        input [15:0]addr;
        input [15:0]data;

        begin
            iIR = 0;
            #9000000;
            iIR = 1;
            #4500000;
            for (i = 0; i < 15; i = i + 1)begin
                bit_send(addr[i]);
            end

            for (i = 0; i <= 7; i = i + 1)begin
                bit_send(data[i]);
            end

            for (i = 0; i <= 7; i = i + 1)begin
                bit_send(~data[i]);
            end

            iIR = 0;
            #5000000;
            iIR = 1;
        end
    endtask

    task bit_send;
        input one_bit;
        begin
            iIR = 0;
            #5600000;
            iIR = 1;
            if (one_bit) begin
                #1690000;
            end
            else begin
                #560000;
            end
        end
    endtask

endmodule
