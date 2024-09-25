module DAC_test(
    Clk,
    Rst_n,

    DAC_CS_N,
    DAC_DIN,
    DAC_SCLK
    );

    input Clk;
    input Rst_n;

    output  DAC_CS_N;
    output  DAC_DIN;
    output  DAC_SCLK;

    reg Start;
    reg [15:0]r_Dac_data;

    wire DAC_STATE;
    wire [15:0]Dac_data;
    wire Set_done;

    issp_dac_tlv5618 issp_dac_tlv5618(
            .probe(),
            .source(Dac_data)
            );

    dac_tlv5618 dac_tlv5618(
        .Clk(Clk),   // clock 50MHz
        .Rst_n(Rst_n), // module reset

        .Start(Start),
        .Dac_data(Dac_data),
        .Set_done(Set_done),

        .CS_N(DAC_CS_N),  // TLV5618 chip select
        .DIN(DAC_DIN),   // data in
        .SCLK(DAC_SCLK),  // serial clock
        .DAC_STATE(DAC_STATE)
        );

    always @(posedge Clk or negedge Rst_n) begin
        if (!Rst_n) begin
            // reset
            r_Dac_data <= Dac_data;
        end
        else if (DAC_STATE) begin
            r_Dac_data <= Dac_data;
        end
    end

    always @(posedge Clk or negedge Rst_n) begin
        if (!Rst_n) begin
            // reset
            Start <= 1'b0;
        end
        else if (r_Dac_data != Dac_data) begin
            Start <= 1'b1;
        end
        else begin
            Start <= 1'b0;
        end
    end

endmodule
