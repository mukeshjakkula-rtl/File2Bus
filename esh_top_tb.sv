module esh_top_tb();
  logic clk,rst;
  logic p_write_in;


 esh_top dut(.clk(clk),
	     .rst(rst),
	     .p_write_in(p_write_in));


initial begin
  clk = 1'b0;
  rst = 1'b1;
  p_write_in = 1'b1;
  #6 rst = 1'b0;
end 
always #5 clk = ~clk;

initial begin
  $dumpfile("esh_top_wave.vcd");
  $dumpvars(0,esh_top_tb);
  #500 $finish;
end 
endmodule 
