module nn_layer #(
    parameter DATA_WIDTH = 16,
    parameter MATRIX_SIZE = 8
)(
    input  wire                         clk,
    input  wire                         rst_n,
    input  wire                         start,
    input  wire [DATA_WIDTH-1:0]        weight [0:MATRIX_SIZE-1][0:MATRIX_SIZE-1],
    input  wire [DATA_WIDTH-1:0]        input_data [0:MATRIX_SIZE-1][0:MATRIX_SIZE-1],
    output wire [DATA_WIDTH*2-1:0]      output_data [0:MATRIX_SIZE-1][0:MATRIX_SIZE-1],
    output wire                         done
);

wire [DATA_WIDTH*2-1:0] matmul_out [0:MATRIX_SIZE-1][0:MATRIX_SIZE-1];
wire matmul_done;
wire [MATRIX_SIZE-1:0] relu_valid_out;
reg  [MATRIX_SIZE-1:0] relu_valid_in;

// 实例化矩阵乘法模块
matrix_mul #(
    .DATA_WIDTH(DATA_WIDTH),
    .MATRIX_SIZE(MATRIX_SIZE)
) u_matrix_mul (
    .clk(clk),
    .rst_n(rst_n),
    .start(start),
    .matrix_a(input_data),
    .matrix_b(weight),
    .matrix_c(matmul_out),
    .done(matmul_done)
);

// 为每一个输出元素实例化ReLU模块
genvar i, j;
generate
    for (i = 0; i < MATRIX_SIZE; i = i + 1) begin : relu_row
        for (j = 0; j < MATRIX_SIZE; j = j + 1) begin : relu_col
            relu #(
                .DATA_WIDTH(DATA_WIDTH*2)
            ) u_relu (
                .clk(clk),
                .rst_n(rst_n),
                .valid_in(relu_valid_in[i]),
                .data_in(matmul_out[i][j]),
                .valid_out(relu_valid_out[i]),
                .data_out(output_data[i][j])
            );
        end
    end
endgenerate

// 控制ReLU的valid信号
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        relu_valid_in <= {MATRIX_SIZE{1'b0}};
    end else begin
        relu_valid_in <= {MATRIX_SIZE{matmul_done}};
    end
end

// 完成信号
assign done = &relu_valid_out;

endmodule