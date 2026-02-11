module read_file(
 input wire  clk,
 output reg valid,
 output reg  [15:0]data_d_out);

 integer fh,ret;
 
initial begin
  valid = 1'b0;
  fh = $fopen("16bit_decimal.csv","r");
  data_d_out = 16'b0;
  while(!$feof(fh)) begin
    valid = 1'b1;
    @(posedge clk)  ret = $fscanf(fh,"%d\n",data_d_out);
    $strobe("%b", data_d_out);
  end 
  if($feof(fh)) valid = 1'b0;
  $fclose(fh);
end 
endmodule 
