module top(count, clk, reset);

	parameter WIDTH = 6;

	output [WIDTH-1: 0] count;
	input  clk, reset;

	wire [WIDTH-1:0] value;
	counter #(WIDTH) counter_1 (count, clk, reset);

endmodule // top
