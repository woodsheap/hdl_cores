module simulation;

	reg rst = 0;
	reg clk = 0;
	reg en = 0;
	wire [7:0] count;
	wire [7:0] out_data;
	wire dr;

	/* Make a reset that pulses once. */
	initial begin
		$dumpfile("simulation.vcd");
		$dumpvars(0, simulation);

		# 17 rst = 1;
		# 11 rst = 0;
		# 29 rst = 1;
		# 11 rst = 0;
		//# 100 $stop;
		# 1000 $finish;
	end

	/* Make a regular pulsing clock. */
	always #5 clk = !clk;

	initial begin
		#60
		forever #10 en = !en;
	end

	top top_logic (count,
	               out_data,
	               dr,
	               en,
	               rst,
	               clk);

	initial
		$monitor("At time %t, value = %h (%0d)",
		         $time, out_data, out_data);
endmodule // simulation
