`timescale 1ns/1ns

module decoder3_8_tb;

//激励信号定义
	reg signal_a;
	reg signal_b;
	reg signal_c;
	
//待检测信号定义
	wire[7:0] code_out;
	
//例化待测试模块
	decoder3_8 decoder3_8_0(
		.a(signal_a),
		.b(signal_b),
		.c(signal_c),
		.out(code_out)
	);
	
//产生激励
	initial begin
		signal_a = 0;
		signal_b = 0;
		signal_c = 0;
		#200;
		signal_a = 0;
		signal_b = 0;
		signal_c = 1;
		#200;		
		signal_a = 0;
		signal_b = 1;
		signal_c = 0;
		#200;		
		signal_a = 0;
		signal_b = 1;
		signal_c = 1;
		#200;		
		signal_a = 1;
		signal_b = 0;
		signal_c = 0;
		#200;		
		signal_a = 1;
		signal_b = 0;
		signal_c = 1;
		#200;		
		signal_a = 1;
		signal_b = 1;
		signal_c = 1;
		#200;
		$stop;	//stop simulation
	end
	
endmodule
