module counter(count, dr, en, rst, clk);

	parameter WIDTH = 8;

	output [WIDTH-1: 0] count;
	output dr;
	input  en, rst, clk;

	reg [WIDTH-1: 0]   count;
	wire     en, rst, clk;
	reg dr;

	always @(posedge clk or posedge rst)
	begin
		if (rst)
			count <= 0;
		else
			dr <= en;
			if (en)
				count <= count + 1;
	end

endmodule // counter
