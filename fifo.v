module sync_fifo#(parameter DATA_WIDTH = 22, FIFO_DEPTH =15, 
                            ADDR_WIDTH = $clog2(FIFO_DEPTH))(
   input wire clk,rst,
   input wire[DATA_WIDTH-1 :0]data_in,
   input wire rd_en,wr_en,
   output reg [DATA_WIDTH-1 :0]data_out,
   output wire full,empty
);

reg [ADDR_WIDTH-1:0]rd_ptr,wr_ptr;
reg [DATA_WIDTH-1:0]mem[0:FIFO_DEPTH-1] = '{default : 0};
wire read, write;
//integer i = 0;

always@(posedge clk) begin
  if(rst) begin
    rd_ptr <= 1'b0;
    wr_ptr <= 1'b0;
    data_out <= 1'b0;
  end else begin
    case({read,write})
      	2'b01 : begin
               mem[wr_ptr] <= data_in;
    	       wr_ptr <= wr_ptr+1;
             end
        2'b10 : begin
	       data_out <= mem[rd_ptr];
	       rd_ptr   <= rd_ptr+1;
	     end
        2'b11 : begin
	       mem[wr_ptr] <= data_in;
	       data_out <= mem[rd_ptr];
               rd_ptr   <= rd_ptr+1;
               wr_ptr   <= wr_ptr+1;
	     end
       2'b00 : begin
               rd_ptr <= rd_ptr;
               wr_ptr <= wr_ptr;
               end
    endcase
  end
end

assign empty = (rd_ptr == wr_ptr);
assign full  = (wr_ptr + 1 == FIFO_DEPTH) ? (0 == rd_ptr) : (wr_ptr + 1 == rd_ptr);
assign write = !full && wr_en;
assign read  = !empty && rd_en;

endmodule 
