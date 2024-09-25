module led_run(mclk,led);
input mclk;
output [7:0] led;
reg [7:0] led;
reg [24:0] count;
reg [3:0] state;
wire clk;

always @ (posedge mclk)
count=count+1'b1;
assign clk=count[24];

always @ (posedge clk)
begin
case(state)
4'd0:led=8'b0000_0001;
4'd1:led=8'b0000_0010;
4'd2:led=8'b0000_0100;
4'd3:led=8'b0000_1000;
4'd4:led=8'b0001_0000;
4'd5:led=8'b0010_0000;
4'd6:led=8'b0100_0000;
4'd7:led=8'b1000_0000;
4'd8:led= 8'b1000_0000;
4'd9:led= 8'b0100_0000;
4'd10:led=8'b0010_0000;
4'd11:led=8'b0001_0000;
4'd12:led=8'b0000_1000;
4'd13:led=8'b0000_0100;
4'd14:led=8'b0000_0010;
4'd15:led=8'b0000_0001;
endcase
state=state+1'b1;
end
endmodule

