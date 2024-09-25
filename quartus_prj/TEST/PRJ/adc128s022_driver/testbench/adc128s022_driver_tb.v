`timescale 1ns/1ns
`define clock_period 20
`define sin_data_file "./sin_12bit.txt"

module adc128s022_driver_tb;

    reg Clk;
    reg Rst_n;
    reg [2:0]Channel;
    wire [11:0]Data;

    wire DIN;
    reg DOUT;
    wire CS_N;
    wire SCLK;

    reg En_Conv;
    wire ADC_STATE;
    wire Conv_Done;
    wire [7:0]Div_PARM; //?wire

    assign Div_PARM = 13;

    reg[11:0] memory[4095:0];   // memory bank

    reg[11:0] address;  // memory address

    adc128s022_driver adc128s022_driver(
        .Clk(Clk),
        .Rst_n(Rst_n),
        .Div_PARM(Div_PARM),
        .Channel(Channel),
        .En_Conv(En_Conv),

        .DIN(DIN),
        .DOUT(DOUT),
        .CS_N(CS_N),
        .ADC_STATE(ADC_STATE),
        .Conv_Done(Conv_Done),
        .SCLK(SCLK),
        .Data(Data)
        );

    initial Clk = 1'b1;
    always #(`clock_period/2) Clk = ~Clk;

    initial $readmemh(`sin_data_file, memory);

    integer i;

    initial begin
        // initilization
        Rst_n = 0;
        Channel = 0;
        En_Conv = 0;
        DOUT = 0;
        address = 0;

        #101;
        Rst_n = 1;

        #100;
        Channel = 5;

        for (i = 0;i < 3;i = i + 1) begin
            for (address = 0;address < 4095;address = address + 1) begin
                En_Conv = 1;
                #20;
                En_Conv = 0;
                gene_DOUT(memory[address]); // read out wave frome memory
                @(posedge Conv_Done);   //wait conversion
                #200;
            end
        end
        #20000;
        $stop;
    end

    // simulate adc data
    task gene_DOUT;
        input [15:0]vdata;
        reg [4:0]cnt;
        begin
            cnt = 0;
            wait(!CS_N);
            while (cnt < 16) begin
                @(negedge SCLK) DOUT = vdata[15 - cnt];
                cnt = cnt + 1'b1;
            end
        end
    endtask

endmodule

