`timescale 1ns / 1ps
module Counter(clk, start, cnt);
input clk, start;
output [0:15] cnt;
reg [0:15] tmp = 16'b0;
reg rst = 0;

always @(posedge clk or posedge start)
	begin
		if(start)
			tmp = 16'b0;
		else
			tmp = tmp + 1'b1;
	end
	
assign cnt = tmp;
endmodule
