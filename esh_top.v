module esh_top(
  input logic clk,rst,
  input logic p_write_in);

 wire valid_w;
 wire [21:0]data_w; 
 wire full_w,empty_w;
 wire [21:0]data_fifo_out_w;
 wire ready_w;
 wire [3:0]addr_w;
 wire [15:0]data_apb_in_w;
 wire psel1,psel2,psel3,psel4;
 wire penable_w;
 wire [15:0]pr_data_w;
 wire [1:0]p_sel_in;
 wire [3:0]addr_out_w;
 wire [15:0]data_out_w;
 wire p_ready_w;
 wire p_write_w;


 assign addr_w = data_fifo_out_w[21:18];
 assign data_apb_in_w = data_fifo_out_w[17:2];
 assign p_sel_in = data_fifo_out_w[1:0];
 
file_reading f1(.clk(clk),
		.valid(valid_w),
		.data(data_w)); // addr and data concatinated from reading file 

sync_fifo f2(.clk(clk),
	     .rst(rst),
	     .data_in(data_w),
	     .wr_en(valid_w),
	     .rd_en(ready_w),
	     .data_out(data_fifo_out_w), // addr and data concatinatted 20 bits
	     .full(full_w),
	     .empty(empty_w));

apb_master f3 (.pclk(clk), 
		.prst(rst), 
		.t_valid(!empty_w), 
		.pready(pready_w),  //----------not working with regular connection----------------------//
		.pwdata_in(data_apb_in_w), //data_wire splitted from fifo data out
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


apb_slave f4(.pclk(clk),
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
