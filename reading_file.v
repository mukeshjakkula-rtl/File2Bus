module file_reading(
  input wire clk,
  output reg valid,
  output reg [21:0]data);

integer fd; // file handle 
integer ret; // line read return value 1 = okay,0 read again , -1 eof
reg [17:0]d_read; 
reg [3:0]addr;

initial begin
   valid = 1'b0;
   addr = 4'b0000;
   fd = $fopen("16_bit_random.txt","r");
     while(!$feof(fd)) begin
        valid = 1'b1;
	@(posedge clk) ret = $fscanf(fd,"%b\n",d_read);
		       addr++;
		       data = {addr,d_read};
       		       $display("%b",data);
   end
   if($feof(fd)) @(posedge clk) valid = 1'b0;
   $fclose(fd);
end 

endmodule 
