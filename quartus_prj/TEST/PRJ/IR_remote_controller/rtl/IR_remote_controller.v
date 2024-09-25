//==================================================================================================
//  Filename      : IR_remote_controller.v
//  Created On    : 2019-07-13 11:16:08
//  Last Modified : 2019-07-13 16:51:21
//  Revision      :
//  Author        : nebulabhm
//  Company       : cg-tech
//  Email         : nebulabhm@gmail.com
//
//  Description   : 红外遥控器解码模块
//
//
//==================================================================================================
module IR_remote_controller(
    Clk,
    Rst_n,
    iIR,

    irData,
    irAddr,
    Get_Flag
    );

    input Clk;
    input Rst_n;
    input iIR;  // 一体化接收头输出数据

    output [15:0]irData;  // 解码得到的数据
    output [15:0]irAddr;  // 解码得到的地址码
    output Get_Flag;    // 一次解码完成标志符号

    reg [18:0]cnt;  // time counter
    reg [3:0]state;

    reg T9ms_ok;
    reg T4_5ms_ok;
    reg T_56ms_ok;
    reg T1_69ms_ok;

    reg Cnt_en;
    reg Get_Data_Done;
    reg timeout;
    reg [5:0]data_cnt;

    reg [31:0]data_tmp;

    wire [15:0]irAddr;
    wire [15:0]irData;

    assign irAddr = data_tmp[15:0];
    assign irData = data_tmp[31:16];

    // state machine 独热码
    localparam
        IDEL = 4'b0001,
        LEADER_T9 = 4'b0010,
        LEADER_T4_5 = 4'b0100,
        DATA_GET = 4'b1000;

    reg s_IR0, s_IR1;

    // two class synchronize signal
    always @(posedge Clk or negedge Rst_n) begin
        if (!Rst_n) begin
            // reset
            s_IR0 <= 1'b0;
            s_IR1 <= 1'b0;
        end
        else begin
            s_IR0 <= iIR;
            s_IR1 <= s_IR0;
        end
    end

    reg s_IR0_Temp, s_IR1_Temp;

    // two class synchronize signal
    always @(posedge Clk or negedge Rst_n) begin
        if (!Rst_n) begin
            // reset
            s_IR0_Temp <= 1'b0;
            s_IR1_Temp <= 1'b0;
        end
        else begin
            s_IR0_Temp <= s_IR1;
            s_IR1_Temp <= s_IR0_Temp;
        end
    end

    wire ir_pedge;  // up edge
    wire ir_nedge;  // down edge

    // get pedge and nedge of input signal
    assign ir_pedge = !s_IR1_Temp && s_IR0_Temp;
    assign ir_nedge = s_IR1_Temp && !s_IR0_Temp;

    // 19 bit counter
    always @(posedge Clk or negedge Rst_n) begin
        if (!Rst_n) begin
            // reset
            cnt <= 19'd0;
        end
        else if (Cnt_en == 1'b1) begin // 控制计数器启动和清零
            cnt <= cnt + 1'b1;
        end
        else begin
            cnt <= 19'd0;
        end
    end

    always @(posedge Clk or negedge Rst_n) begin
        if (!Rst_n) begin
            // reset
            timeout <= 0;
        end
        else if (cnt >= 19'd500000) begin
            timeout <= 1'b1;
        end
        else begin
            timeout <= 1'b0;
        end
    end

    // 9ms counter
    always @(posedge Clk or negedge Rst_n) begin
        if (!Rst_n) begin
            // reset
            T9ms_ok <=0;
        end
        else if (cnt > 19'd325000 && cnt < 19'd49500) begin
            T9ms_ok <= 1'b1;
        end
        else begin
            T9ms_ok <= 0;
        end
    end

    // 4.5ms counter
    always @(posedge Clk or negedge Rst_n) begin
        if (!Rst_n) begin
            // reset
            T4_5ms_ok <= 0;
        end
        else if (cnt > 19'd152500 && cnt < 19'd277500) begin
            T4_5ms_ok <= 1;
        end
        else begin
            T4_5ms_ok <= 0;
        end
    end

    // 0.56ms counter
    always @(posedge Clk or negedge Rst_n) begin
        if (!Rst_n) begin
            // reset
            T_56ms_ok <= 0;
        end
        else if (cnt > 19'd20000 && cnt < 19'd35000) begin
            T_56ms_ok <= 1;
        end
        else begin
            T_56ms_ok <= 0;
        end
    end

    // 1.69ms counter
    always @(posedge Clk or negedge Rst_n) begin
        if (!Rst_n) begin
            // reset
            T1_69ms_ok <= 0;
        end
        else if (cnt > 19'd75000 && cnt < 19'd90000) begin
            T1_69ms_ok <= 1;
        end
        else begin
            T1_69ms_ok <= 0;
        end
    end

    // decoder state machine
    always @(posedge Clk or negedge Rst_n) begin
        if (!Rst_n) begin
            // reset
            state <= IDEL;
            Cnt_en <= 1'b0;
        end
        else if (timeout) begin
            case(state)
                IDEL:
                    if (ir_nedge) begin
                        Cnt_en <= 1'b1;
                        state <= LEADER_T9;
                    end
                    else begin
                        state <= IDEL;
                        Cnt_en <= 1'b0;
                    end

                LEADER_T9:
                    if (ir_pedge) begin
                        // 满足9ms 低电平进入下一个4.5ms高电平判断状态
                        if (T9ms_ok) begin
                            Cnt_en <= 1'b0;
                            state <= LEADER_T4_5;
                        end
                        // 9ms 低电平没有满足，返回IDEL状态等待
                        else begin
                            state <= IDEL;
                        end
                    end
                    else begin
                        state <= LEADER_T9;
                        Cnt_en <= 1'b1;
                    end

                LEADER_T4_5:
                    if (ir_nedge) begin
                        if (T4_5ms_ok) begin
                            Cnt_en <= 1'b0;
                            state <= DATA_GET;
                        end
                        else begin
                            state <= IDEL;
                        end
                    end
                    else begin
                        state <= LEADER_T4_5;
                        Cnt_en <= 1'b1;
                    end

                DATA_GET:
                    if (ir_pedge && !T_56ms_ok) begin
                        state <= IDEL;
                    end
                    else if (ir_nedge && (!T_56ms_ok && !T1_69ms_ok)) begin
                        state <= IDEL;
                    end
                    else if (Get_Data_Done) begin
                        state <= IDEL;
                    end
                    else if (ir_pedge && T_56ms_ok) begin
                        Cnt_en <= 1'b0;
                    end
                    else if (ir_nedge && (T_56ms_ok || T1_69ms_ok)) begin
                        Cnt_en <= 1'b0;
                    end
                    else begin
                        Cnt_en <= 1'b1;
                    end

                default:;
            endcase
        end
        else begin
            Cnt_en <= 1'b0;
            state <= IDEL;
        end
    end


    // data decoder
    always @(posedge Clk or negedge Rst_n) begin
        if (!Rst_n) begin
            // reset
            Get_Data_Done <= 1'b0;
            data_cnt <= 6'd0;
            data_tmp <= 32'd0;
        end
        else if (state == DATA_GET) begin
            if (ir_pedge && (data_cnt == 6'd32)) begin
                data_cnt <= 6'd0;
                Get_Data_Done <= 1'b1;
            end
            else begin
                if (ir_nedge) begin
                    data_cnt <= data_cnt + 1'b1;
                end
                if (ir_nedge && T_56ms_ok) begin
                    data_tmp[data_cnt] <= 1'b0;
                end
                else if (ir_nedge && T1_69ms_ok) begin
                    data_tmp[data_cnt] <= 1'b1;
                end
                Get_Data_Done <= 1'b0;
            end
        end
    end

    assign Get_Flag = Get_Data_Done;

endmodule
