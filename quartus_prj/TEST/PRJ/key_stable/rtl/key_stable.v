module key_stable(Clk, Rst_n, key_in, key_flag, key_state);

	input Clk;
	input Rst_n;
	input key_in;
	
	output reg key_flag;
	output reg key_state;
//code...
	reg key_in_a, key_in_b;
	// 单bit异步信号同步
	always@(posedge Clk or negedge Rst_n)
		if (!Rst_n)
			begin
				key_in_a <= 1'b0;
				key_in_b <= 1'b0;
			end
		else 
			begin
				key_in_a <= key_in;
				key_in_b <= key_in_a;
			end
	
	// 边沿检测
	reg key_tmpa, key_tmpb;
	wire pedge, nedge;
	always@(posedge Clk or negedge Rst_n)
		if (!Rst_n)
			begin
				key_tmpa <= 1'b0;
				key_tmpb <= 1'b0;
			end
		else
			begin
				key_tmpa <= key_in;
				key_tmpb <= key_tmpa;
			end
		assign nedge = !key_tmpa && key_tmpb;
		assign pedge = key_tmpa && (!key_tmpb);
		
	// counter enable
	reg [19:0] cnt;
	reg en_cnt;
	always@(posedge Clk or negedge Rst_n)
		if (!Rst_n)
			cnt <= 20'd0;
		else if (en_cnt)
			cnt <= cnt + 1'b1;
		else
			cnt <= 20'd0;
	
	// counter
	reg cnt_full;
	always@(posedge Clk or negedge Rst_n)
		if (!Rst_n)
			cnt_full <= 1'b0;
		else if (cnt == 20'd999_999)
			cnt_full <= 1'b1;
		else 
			cnt_full <= 1'b0;
	
	// state machine
	localparam 
		IDLE		= 4'b0001,
		FILTER0 	= 4'b0010,
		DOWN		= 4'b0100,
		FILTER1	= 4'b1000;
		
	reg [3:0] state;
	always@(posedge Clk or negedge Rst_n)
		if (!Rst_n)
			begin	
				en_cnt <= 1'b0;
				state <= IDLE;
				key_flag <= 1'b0;
				key_state <= 1'b1;
			end
		else 
			begin
				case (state)
					//code...
					IDLE:
						begin
							key_flag <= 1'b0;
							if (nedge)
								begin
									state <= FILTER0;
									en_cnt <= 1'b1;
								end
							else
								state <= IDLE;
						end
						
					FILTER0:
						begin
							if (cnt_full)
								begin
									key_flag <= 1'b1;
									key_state <= 1'b0;
									en_cnt <= 1'b0;
									state <= DOWN;
								end
							else if (pedge)
								begin
									state <= IDLE;
									en_cnt <= 1'b0;
								end
							else
								state <= FILTER0;
						end
					DOWN:
						begin
							key_flag <= 1'b0;
							if (pedge) 
								begin
									state <= FILTER1;
									en_cnt <= 1'b1;
								end
							else
								state <= DOWN;
						end
					FILTER1:
						begin
							if (cnt_full) 
								begin
									key_flag <= 1'b1;
									key_state <= 1'b1;
									state <= IDLE;
									en_cnt <= 1'b0;
								end
							else if (nedge) 
								begin
									en_cnt <= 1'b0;
									state <= DOWN;
								end
							else
								state <= FILTER1;
						end
						
					default:
						begin
							state <= IDLE;
							en_cnt <= 1'b0;
							key_flag <= 1'b0;
							key_state <= 1'b1;
						end
				endcase
			end
			
endmodule
