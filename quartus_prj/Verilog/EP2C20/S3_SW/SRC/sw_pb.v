module sw_pb(sw,pb,led);
input [7:0]sw,pb;
output [7:0] led;
wire [7:0] led;
assign led=~sw;
//assign led=pb;
endmodule