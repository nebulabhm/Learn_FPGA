module matrix_mul #(
    parameter DATA_WIDTH = 16,
    parameter MATRIX_SIZE = 8
)(
    input  wire                         clk,
    input  wire                         rst_n,
    input  wire                         start,
    input  wire [DATA_WIDTH-1:0]        matrix_a [0:MATRIX_SIZE-1][0:MATRIX_SIZE-1],
    input  wire [DATA_WIDTH-1:0]        matrix_b [0:MATRIX_SIZE-1][0:MATRIX_SIZE-1],
    output reg  [DATA_WIDTH*2-1:0]      matrix_c [0:MATRIX_SIZE-1][0:MATRIX_SIZE-1],
    output reg                          done
);

reg [DATA_WIDTH*2-1:0] acc;
reg [$clog2(MATRIX_SIZE):0] i, j, k;
reg computing;

// 状态机控制
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        computing <= 1'b0;
        done <= 1'b0;
        i <= 0;
        j <= 0;
        k <= 0;
    end else begin
        if (start && !computing) begin
            computing <= 1'b1;
            done <= 1'b0;
            i <= 0;
            j <= 0;
            k <= 0;
        end else if (computing) begin
            if (k == MATRIX_SIZE) begin
                matrix_c[i][j] <= acc;
                k <= 0;
                acc <= 0;
                if (j == MATRIX_SIZE-1) begin
                    j <= 0;
                    if (i == MATRIX_SIZE-1) begin
                        computing <= 1'b0;
                        done <= 1'b1;
                    end else begin
                        i <= i + 1;
                    end
                end else begin
                    j <= j + 1;
                end
            end else begin
                acc <= acc + matrix_a[i][k] * matrix_b[k][j];
                k <= k + 1;
            end
        end
    end
 end

endmodule