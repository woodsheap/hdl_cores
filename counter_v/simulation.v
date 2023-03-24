module sim_test;

  /* Make a reset that pulses once. */
  reg reset = 0;
  initial begin
     $dumpfile("simulation.vcd");
     $dumpvars(0, sim_test);

     # 17 reset = 1;
     # 11 reset = 0;
     # 29 reset = 1;
     # 11 reset = 0;
     //# 100 $stop;
     # 200 $finish;
  end

  /* Make a regular pulsing clock. */
  reg clk = 0;
  always #5 clk = !clk;

  wire [5:0] value;
  top top_logic (value, clk, reset);

  initial
     $monitor("At time %t, value = %h (%0d)",
              $time, value, value);
endmodule // sim_test
