module relu #(
    parameter DATA_WIDTH = 32
)(
    input  wire                    clk,
    input  wire                    rst_n,
    input  wire                    valid_in,
    input  wire [DATA_WIDTH-1:0]   data_in,
    output reg                     valid_out,
    output reg  [DATA_WIDTH-1:0]   data_out
);

// ReLU激活函数：f(x) = max(0, x)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        valid_out <= 1'b0;
        data_out <= 0;
    end else begin
        valid_out <= valid_in;
        // 如果输入为负数，输出0；否则保持输入值不变
        data_out <= ($signed(data_in) < 0) ? 0 : data_in;
    end
end

endmodule