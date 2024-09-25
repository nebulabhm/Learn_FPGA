`timescale 1ns/1ns

module adc128s022_driver(
    Clk,
    Rst_n,
    Div_PARM,
    Channel,
    En_Conv,

    DIN,
    DOUT,
    CS_N,
    ADC_STATE,
    Conv_Done,
    SCLK,
    Data);

    input Clk;  // clock    50MHz
    input Rst_n;    // reset
    input [7:0]Div_PARM; // frequency division number SCLK = Clk / (Div_PARM X 2)
    input [2:0]Channel;  // adc channel selection
    input En_Conv;  // enable single adc conversion, one adc period

    output reg DIN; // adc control data in
    input DOUT; // adc data out
    output reg CS_N;    // chip select
    output reg SCLK;    // spi clock
    output ADC_STATE;   // adc state work: 0, idle: 1
    output reg Conv_Done;   // adc sample done flag
    output reg [11:0]Data;    // adc data

    wire ADC_STATE;

    reg [2:0]r_Channel;
    reg [11:0]r_Data;

    reg [7:0]DIV_CNT;   // division frequencial counter
    reg SLCK2X;

    reg en;

    // reg Channel value preventing from change during adc
    always @(posedge Clk or negedge Rst_n) begin
        if (!Rst_n) begin
            // reset
            r_Channel <= 3'd0;
        end
        else if (En_Conv) begin
            r_Channel <= Channel;
        end
        else begin
            r_Channel <= r_Channel;
        end
    end

    // generate enable signal
    always @(posedge Clk or negedge Rst_n) begin
        if (!Rst_n) begin
            // reset
            en <= 1'b0;
        end
        else if (En_Conv) begin
            en <= 1'b1;
        end
        else if (Conv_Done) begin
            en <= 1'b0;
        end
        else begin
            en <= en;
        end
    end

    // generate 2xsclk numerator
    always @(posedge Clk or negedge Rst_n) begin
        if (!Rst_n) begin
            // reset
            DIV_CNT <= 8'd0;
        end
        else if (en) begin
            if (DIV_CNT == (Div_PARM - 1'b1)) begin
                DIV_CNT <= 8'd0;
            end
            else begin
                DIV_CNT <= DIV_CNT + 1'b1;
            end
        end
        else begin
            DIV_CNT <= 8'd0;
        end
    end

    // generate 2xsclk
    always @(posedge Clk or negedge Rst_n) begin
        if (!Rst_n) begin
            // reset
            SLCK2X <= 1'b0;
        end
        else if (en && (DIV_CNT == (Div_PARM - 1'b1))) begin
            SLCK2X <= 1'b1;
        end
        else begin
            SLCK2X  <= 1'b0;
        end
    end

    // count when enable, time serial counter
    reg [5:0]SCLK_GEN_CNT;
    always @(posedge Clk or negedge Rst_n) begin
        if (!Rst_n) begin
            // reset
            SCLK_GEN_CNT <= 6'd0;
        end
        else if (en && SLCK2X) begin
            if (SCLK_GEN_CNT == 6'd33) begin
                SCLK_GEN_CNT <= 6'd0;
            end
            else begin
                SCLK_GEN_CNT <= SCLK_GEN_CNT + 1'd1;
            end
        end
        else begin
            SCLK_GEN_CNT <= SCLK_GEN_CNT;
        end
    end

    // time serial process
    always @(posedge Clk or negedge Rst_n) begin
        if (!Rst_n) begin
            // reset
            SCLK <= 1'b1;
            CS_N <= 1'b1;
            DIN <= 1'b1;
        end
        else if (en) begin
            if (SLCK2X) begin
                case (SCLK_GEN_CNT)
                    // code
                    6'd0: begin
                        CS_N <= 1'b0;
                    end
                    6'd1:begin
                        SCLK <= 1'b0;
                        DIN <= 1'b0;
                    end
                    6'd2,6'd4,6'd6,6'd8:begin
                        SCLK <= 1'b1;
                    end
                    6'd3,6'd11,6'd13,6'd15,6'd17,6'd19,6'd21,6'd23,6'd25,6'd27,6'd29,6'd31:begin
                        SCLK <= 1'b0;
                    end
                    6'd5: begin
                        SCLK <= 1'b0;
                        DIN <= r_Channel[2];
                    end
                    6'd7: begin
                        SCLK <= 1'b0;
                        DIN <= r_Channel[1];
                    end
                    6'd9: begin
                        SCLK <= 1'b0;
                        DIN <= r_Channel[0];
                    end
                    6'd10: begin
                        SCLK <= 1'b1;
                        r_Data[11] <= DOUT;
                    end
                    6'd12: begin
                        SCLK <= 1'b1;
                        r_Data[10] <= DOUT;
                    end
                    6'd14: begin
                        SCLK <= 1'b1;
                        r_Data[9] <= DOUT;
                    end
                    6'd16: begin
                        SCLK <= 1'b1;
                        r_Data[8] <= DOUT;
                    end
                    6'd18: begin
                        SCLK <= 1'b1;
                        r_Data[7] <= DOUT;
                    end
                    6'd20: begin
                        SCLK <= 1'b1;
                        r_Data[6] <= DOUT;
                    end
                    6'd22: begin
                        SCLK <= 1'b1;
                        r_Data[5] <= DOUT;
                    end
                    6'd24: begin
                        SCLK <= 1'b1;
                        r_Data[4] <= DOUT;
                    end
                    6'd26: begin
                        SCLK <= 1'b1;
                        r_Data[3] <= DOUT;
                    end
                    6'd28: begin
                        SCLK <= 1'b1;
                        r_Data[2] <= DOUT;
                    end
                    6'd30: begin
                        SCLK <= 1'b1;
                        r_Data[1] <= DOUT;
                    end
                    6'd32: begin
                        SCLK <= 1'b1;
                        r_Data[0] <= DOUT;
                    end
                    6'd33: begin
                        CS_N <= 1'b1;
                    end
                    default: begin
                        CS_N <= 1'b1;
                    end
                endcase
            end
        end
        else begin
            CS_N <= 1'b1;
        end
    end

    always @(posedge Clk or negedge Rst_n) begin
        if (!Rst_n) begin
            // reset
            Data <= 12'd0;
            Conv_Done <= 1'b0;
        end
        else if (en && SLCK2X && (SCLK_GEN_CNT == 6'd33)) begin
            Data <= r_Data;
            Conv_Done <= 1'b1;
        end
        else begin
            Data <= Data;
            Conv_Done <= 1'b0;
        end
    end

    // generate work state signal
    assign  ADC_STATE = CS_N;


endmodule
