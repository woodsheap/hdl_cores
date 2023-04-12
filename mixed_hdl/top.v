module top(count, out_data, dr, en, rst, clk);

	parameter WIDTH = 8;

	output [WIDTH-1: 0] count;
	output [WIDTH-1: 0] out_data;
	output dr;
	input  en, clk, rst;

	wire [WIDTH-1: 0] counter;
	wire counter_to_filter;

	assign count = counter;
	counter #(WIDTH) counter_1 (counter,
	                            counter_to_filter,
	                            en,
	                            rst,
	                            clk);
	averaging_filter_cfg filter_1(counter,
	                              counter_to_filter,
	                              rst,
	                              clk,
	                              out_data,
	                              dr);

endmodule // top
