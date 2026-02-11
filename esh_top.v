module esh_top(
  input logic clk,rst,
  input logic p_write_in);

 wire valid_w;
 wire [21:0]data_w; 
 wire full_bin_w,empty_bin_w,full_dec_w,empty_dec_w,empty_w;
 wire [21:0]data_fifo_out_w;
 wire ready_w;
 wire [3:0]addr_w;
 wire [15:0]data_apb_in1_w,data_apb_in2_w;
 wire [16:0]data_sum_apb_in_w;
 wire psel1,psel2,psel3,psel4;
 wire penable_w;
 wire [16:0]pr_data_w;
 wire [1:0]p_sel_in;
 wire [3:0]addr_out_w;
 wire [16:0]data_out_w; //txt file binary value data 
 wire [15:0]data_out_csv_w; // csv file data out wire connected to fifo 
 wire [15:0]data_csv_fifo_out_w; // csv file decimal value data fifo out wire connected to apb
 wire valid_csv_w;
 wire p_ready_w;
 wire p_write_w;

 assign empty_w = empty_dec_w & empty_bin_w;
 assign addr_w = data_fifo_out_w[21:18];
 assign data_apb_in1_w = data_fifo_out_w[17:2]; // binary values input to adder
 assign p_sel_in = data_fifo_out_w[1:0];
 assign data_apb_in2_w = data_csv_fifo_out_w; // decimal values input to adder
 

/////////////---reading the data from binarytxt file---///////////////////

file_reading f1(.clk(clk),
		.valid(valid_w),
		.data(data_w)); // addr and data concatinated from reading file

sync_fifo  #(.DATA_WIDTH(22),
	     .FIFO_DEPTH(15))
	  f2(.clk(clk),
	     .rst(rst),
	     .data_in(data_w),
	     .wr_en(valid_w),
	     .rd_en(ready_w),
	     .data_out(data_fifo_out_w), // addr and data concatinatted 20 bits
	     .full(full_bin_w),
	     .empty(empty_bin_w));



///////////////---reading the data from csv decimal file---////////////////////////////

read_file g1(.clk(clk),
             .valid(valid_csv_w),
	     .data_d_out(data_out_csv_w));
		


sync_fifo  #(.DATA_WIDTH(16), 
             .FIFO_DEPTH(15))
          g2(.clk(clk),
	     .rst(rst),
	     .data_in(data_out_csv_w),
	     .wr_en(valid_csv_w),
	     .rd_en(ready_w),
	     .data_out(data_csv_fifo_out_w), // addr, data and psel concatinatted 22 bits
	     .full(full_dec_w),
	     .empty(empty_dec_w));

//////////////---ripple adder---/////////////////////////////////////////

ripple_adder #(.DATA_WIDTH(16))
	     c1(.A(data_apb_in1_w),
	        .B(data_apb_in2_w),
		.S_out(data_sum_apb_in_w));


///////---apb_master and slave data bus---////////////////////////////////////////////

 apb_master   #(.DATA_WIDTH(17),
	        .ADDR_WIDTH(4))
	    b1 (.pclk(clk), 
		.prst(rst), 
		.t_valid(!empty_w), 
		.pready(pready_w),  
		.pwdata_in(data_sum_apb_in_w), //data_wire splitted from fifo data out
		.paddr_in(addr_w), // addr_wire splitted from fifo data out
		.prdata(pr_data_w), //
		.pwdata(data_out_w), 
		.paddr(addr_out_w), 
		.pwrite(p_write_w), 
		.psel1(psel1),
		.psel2(psel2),
		.psel3(psel3),
		.psel4(psel4),
		.penable(penable_w),
		.pwrite_in(p_write_in),
		.psel_in(p_sel_in), // explicitly selecting a slave
		.ready(ready_w));


apb_slave  #(.DATA_WIDTH(17),
	     .ADDR_WIDTH(4))
          b2(.pclk(clk),
	     .prst(rst),
	     .t_valid(!empty_w),
	     .paddr(addr_out_w),
	     .pwdata(data_out_w),
	     .penable(penable_w),
	     .pwrite(p_write_w), //input from top
	     .psel(psel1),
	     .prdata(pr_data_w),
	     .pready(pready_w));

		
endmodule 
